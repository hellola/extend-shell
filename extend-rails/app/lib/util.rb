require 'socket'
require 'alias'
require 'function'
require 'hotkey'
require 'environment'
require 'byebug'

module Util
  def self.hostname
    Socket.gethostname
  end

  def self.hashify_linux_style(text)
    result = {}
    text.split("\n").each do |line|
      pair = line.split('=')
      result[pair[0]] = pair[1]
    end
    result
  end

  def self.parse_key_value(als)
    split = als.split('=')
    name, command = split[0], split[1] if split.length == 2
    name, command = split[0], split[1..-1].join('=') if split.length > 2
    # TODO:  i'm sure there is a more elegant way to do this 
    command = command[1..-2] if command[0] == "'" && command[-1] == "'"
    command = command.gsub(/\\\$/, '$')
    [name, command]
  end

  def self.render_destruction(destructions)
    File.write("#{$extend_path}/destruct.zsh", destructions)
  end

  def self.sanitize_path(path)
    path.tr('^', ' ')
  end

  def self.render_all(pwd)
     Alias.load_all(path: pwd).join("\n") + "\n" +
      Function.load_all(path: pwd).join("\n") + "\n" +
      Hotkey.load_all(path: pwd).join("\n") + "\n" +
      Environment.load_all(path: pwd).join("\n") + "\n"
  end

  def self.render_wm_key_search
    type = HotkeyType.find_by(name: 'window_manager')
    keys = Hotkey.load_names(type: type).join("\n") + "\n"
  end

  def self.render_command_search(pwd)
    Alias.load_names(path: pwd).join("\n") + "\n" +
      Function.load_names(path: pwd).join("\n") + "\n"
  end
end
