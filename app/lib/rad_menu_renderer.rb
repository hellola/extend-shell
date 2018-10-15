require 'hotkey_renderer'

class RadMenuRenderer < HotkeyRenderer
  def joiner
    ",\n"
  end

  def render_pre
    "\n["
  end

  def render_post
    "\n]"
  end

  def render_leaf(stack, hotkey)
    render_standalone(stack, hotkey)
  end

  def render_branch(stack, hotkey)
    render_standalone(stack, hotkey)
  end

  def render_standalone(stack, hotkey)
    weight = 1
    action = hotkey.command.to_json
    action = '""' if action == 'null'
    json = <<-JSON_END
    {
      "name": "#{hotkey.display_name}",
      "short_name": "#{hotkey.short_name}",
      "action" : #{action},
      "weight" : #{weight},
      "menu" : #{render_sub_menu(stack, hotkey)}
    }
    JSON_END
    json
  end

  def render_sub_menu(stack, hotkey)
    return '[]' if hotkey.children.nil? || hotkey.children.count == 0
    built = '['
    hotkey.children.each do |child|
      built += "#{render_standalone(stack, child)},"
    end
    built = built.chomp(',')
    built + ']'
  end

  def render_branch_tail(stack, hotkey)
    ""
  end
end
