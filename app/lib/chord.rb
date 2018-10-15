require 'yaml'

class Chord
  def self.render_keys(pwd)
    aliases = Alias.all
    functions = Function.all
    commands = aliases + functions
    keys = commands.map do |c|
      c.render_key
    end
    key_res = keys.reduce({}, :deep_merge)
    key_res.to_yaml
  end
end
