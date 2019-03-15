require 'hotkey_renderer'

class SxhkdRenderer < HotkeyRenderer
  def render_leaf(stack, hotkey)
    "##{hotkey.full_name} (#{hotkey.id})\n#{stack} ; #{hotkey.key}\n  #{hotkey.command}\n\n"
  end

  def render_standalone(stack, hotkey)
    "##{hotkey.full_name} (#{hotkey.id})\n#{stack} #{hotkey.key}\n  #{hotkey.command}\n\n"
  end

  def render_branch(stack, hotkey)
    concatenation = hotkey.children? ? ' ; ' : ' + '
    concatenation = ' + ' if hotkey.parent.nil?
    "#{concatenation}#{hotkey.key}"
  end

  def render_branch_tail(stack, hotkey)
    ''
  end
end
