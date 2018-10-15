class Environment < ApplicationRecord
  include StorableCommand

  def render
    "export #{name}=#{value}"
  end

  def self.create_from_raw(raw_env, category,  path, global_options)
    name, value = Util::parse_key_value(raw_env)
    env = Environment.new(name: name, value: value, location: Location.find_or_create_from_path(path))
    env.apply_global_options(global_options)
    # TODO: executes by default for now
    if category.present?
      category.split(' ').each do |cat|
        env.categories << Category.find_or_create_by(name: cat)
      end
    end
    env.save
  end

  def to_s
    "#{name}=#{value} (#{location.path})"
  end
end
