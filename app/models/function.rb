class Function < ApplicationRecord
  include StorableCommand
  include Shortcut
  include Executable

  def render
    "function #{shortcut}-#{name} { #{body} }\n" + 
    "alias #{shortcut}=#{shortcut}-#{name} ##{id}"
  end


  def command
    #TODO: accept arguments to function
    name
  end

  def self.create_from_raw(function_raw, category, path, global_options)
    name, body = Util::parse_key_value(function_raw)
    function = Function.new(name: name, body: body)
    function.apply_global_options(global_options)
    function.location = Location.find_or_create_from_path(path)
    if category.present?
      category.split(' ').each do |cat|
        function.categories << Category.find_or_create_by(name: cat)
      end
    end
    function.save
  end

  def to_s
    "function #{shortcut}-#{name} { #{body} }"
  end

end
