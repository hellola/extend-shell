class Startup < ApplicationRecord
  include Shortcut
  include StorableCommand

  def self.create_from_raw(raw_alias, category, path, global_options)
    name, command = Util::parse_key_value(raw_alias)
    startup = Startup.new(name: name, command: command)
    startup.apply_global_options(global_options)
    startup.location = Location.find_or_create_from_path(path)
    if category.present?
      category.split(' ').each do |cat|
        startup.categories << Category.find_or_create_by(name: cat)
      end
    end
    startup.save
  end

  def self.should_run?
    return false if File.exist?('/tmp/extend')
    FileUtils.touch('/tmp/extend')
    true
  end

  def execute_sync
    executable&.execute
  end

  def executable
    return if executable_id.nil?
    executable = Executable.load_executable(executable_id)
  end

  def render
    executable&.command
  end

  def command
    executable&.command
  end
end
