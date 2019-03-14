module Shortcut
  extend ActiveSupport::Concern

  included do
    def self.destroy_with_shortcut(name)
      # TODO: do this better?
      self.all.each do |a|
        a.destroy if a.shortcut == name
      end
    end

    def shortcut
      return nil if name.nil?
      name.split(/[_-]/).map { |w| w[0] }.join('')
    end

    def render_key
      render_key_recurse(shortcut.chars, -1)
    end

    def render_key_recurse(tail, word_num)
      return { mnemonic: "#{name.split('-')[word_num]}",  tail[0].to_s => render_key_recurse(tail[1..-1], word_num+1) } if tail.count > 0
      { name: "#{shortcut}-#{name}", command: "#{shortcut}-#{name}" }
    end
  end
end
