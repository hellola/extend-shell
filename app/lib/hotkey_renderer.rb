
class HotkeyRenderer
  def joiner
    "\n"
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
