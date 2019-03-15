class Alias < ApplicationRecord
  include StorableCommand
  include Shortcut
  include Executable

  def render
    "alias #{shortcut}-#{full_name}='#{command}' ##{id}\n" +
    "alias #{shortcut}='#{command}'"
  end

  def self.create_from_raw(raw_alias, category, path, global_options)
    name, command = Util::parse_key_value(raw_alias)
    als = Alias.new(name: name, command: command)
    als.apply_global_options(global_options)
    als.location = Location.find_or_create_from_path(path)
    if category.present?
      category.split(' ').each do |cat|
        als.categories << Category.find_or_create_by(name: cat)
      end
    end
    als.save
  end

  def to_raw
    # TODO add operating system and path for full rawness
    "extend-shell alias add #{name}=#{command}"
  end

  def destruct(name)
    "unalias #{shortcut}-#{name}\n" +
    "unalias #{shortcut}\n"
  end

  def to_s
    path = ""
    path = "(#{location.path})" if location.path.present?
    "alias #{shortcut}-#{name}='#{command}' #{path}"
  end
end
