
class HotkeyRenderer
  def joiner
    "\n"
  end

  # Use this to render any specific stack details
  def render_branch_head(stack, hotkey)
    ''
  end

  def render_leaf(stack, hotkey)
    raise 'Not implemented'
  end

  def render_standalone(stack, hotkey)
    raise 'Not implemented'
  end

  def render_branch(stack, hotkey)
    raise 'Not implemented'
  end

  def render_branch_tail(stack, hotkey)
    raise 'Not implemented'
  end

  def render_pre
    ''
  end

  def render_post
    ''
  end
  
end
