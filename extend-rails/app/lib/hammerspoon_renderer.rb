require 'hotkey_renderer'

class HammerspoonRenderer < HotkeyRenderer
  def initialize
    @branches_declared = {}
    @branches_declared['test'] = true
  end

  def render_pre
    render_choices_table
  end

  def render_choices_table
    rendered = "local extend_choices = {"
    list = leaf_keys.map do |key|
      <<-DOC
      {
        ["text"] = "#{text}",
        ["subText"] = "#{description}",
        ["uuid"] = "#{id}"
      }
      DOC
    end.join(',')
    rendered += list
    rendered += "}"
  end

  def translate_from_standard_key(key_string)
    key_string
      .gsub(/apostrophe/,"\\\\'")
      .gsub(/comma/,',')
      .gsub(/semicolon/, ';')
      .gsub(/period/,'.')
      .gsub(/plus/,'=')
      .gsub(/question/,'/')
      .gsub(/minus/,'-')
      .gsub(/slash/,'/')
  end

  def before_render(stack, hotkey)
    stack = translate_from_standard_key(stack)
    hotkey.key = translate_from_standard_key(hotkey.key)
  end

  def render_leaf(stack, hotkey)
    before_render(stack, hotkey)
    modal_var = "extend_key_#{variablize(stack).split(',').join('_')}"
    stack = stack.split(',').map { |k| "'#{k}'" }.join(',')
    command_binding =
      if hotkey.executes
        "hs.execute('#{escape(hotkey.command)}', true)"
      else
        hotkey.command
      end
    pressed_message =
      if @show_messages
        "'pressed #{hotkey.key}'"
      else
        'nil'
      end
    <<-DOC
    #{modal_var}:bind('', '#{hotkey.key}', #{pressed_message},
        function()
          #{command_binding}
          #{modal_var}:exit()
    end)
    DOC
  end

  def escape(command)
    command.gsub(/\'/, "\\\\'")
  end

  def render_standalone(stack, hotkey)
    before_render(stack, hotkey)
    stack = stack.split(',').map { |k| "'#{k}'" }.join(',')
    <<-DOC
    -- #{hotkey.full_name} (#{hotkey.id})
    hs.hotkey.bind({#{stack}}, "#{hotkey.key}", function()
        hs.execute('#{hotkey.command}', true)
    end)
    DOC
  end

  def branch_declared?(stack)
    @branches_declared[stack].present?
  end

  def branch_declared!(stack)
    # puts @branches_declared
    # @branches_declared[stack] = true
  end

  def variablize(text)
    text
      .gsub(/\//, 'fwslash')
      .gsub(/\?/, 'question')
  end

  def render_branch_head(stack, hotkey)
    before_render(stack, hotkey)
    return if branch_declared?(stack)
    return unless hotkey.children?
    branch_declared!(stack, )
    modal_var = "extend_key_#{variablize(stack).split(',').join('_')}_#{variablize(hotkey.key)}"
    stack = stack.split(',').map { |k| "'#{k}'" }.join(',')
    <<-DOC
    -- branch: #{stack}_#{hotkey.key}
    #{modal_var} = hs.hotkey.modal.new(#{stack}, '#{hotkey.key}')

    function #{modal_var}:entered()
      -- for debugging
      -- hs.alert 'entered branch #{modal_var}'
    end
    function #{modal_var}:exited()
      -- for debugging
      -- hs.alert 'exited mode'
    end

    -- #{modal_var}:bind('', 'escape', function() #{modal_var}:exit() end)
    DOC
  end

  def render_branch(stack, hotkey)
    before_render(stack, hotkey)
    concatenation = hotkey.children? ? ',' : ','
    concatenation = ',' if hotkey.parent.nil?
    "#{concatenation}#{hotkey.key}"
  end

  def render_branch_tail(stack, hotkey)
    before_render(stack, hotkey)
    ''
  end
end
