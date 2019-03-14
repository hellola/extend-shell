class Hotkey < ApplicationRecord
  include Shortcut
  include StorableCommand
  include Executable

  belongs_to :hotkey_type
  belongs_to :parent, class_name: 'Hotkey', foreign_key: 'parent_id'
  has_many :children, class_name: 'Hotkey', foreign_key: 'parent_id'
  scope :with_type, -> { joins(:hotkey_type) }

  def self.render_window_keys(pwd = nil)
    render_using_renderer(renderer: SxhkdRenderer.new, default_stack: 'alt')
  end

  def self.render_window_menu_keys(pwd = nil)
    '[' +
      render_using_renderer(renderer: RadMenuRenderer.new, recursive: true) +
      ']'
  end

  def self.render_using_renderer(renderer:, default_stack: '', recursive: false)
    root = []
    root_hotkeys = Hotkey.with_type.where(hotkey_types: { name: 'window_manager' }, parent: nil)
    root_hotkeys.each do |hk|
      root << hk.render_with_children(nil, renderer, default_stack: default_stack, recursive: recursive)
    end
    root.join(renderer.joiner)
  end

  def full_key
    "#{parent.key}-#{full_key}" if parent.present?
    key
  end

  def gen_full_name
    "#{parent.name}-#{self[:name]}" if parent.present?
  end

  def display_name
    return '' if self[:name].nil?
    self[:name].tr('_', ' ')
  end

  def short_name
    return '' if self[:name].nil?
    init = ''
    init = self[:name][0] if /^[aeiou]/i.match(self[:name])
    init + self[:name].gsub(/[aeiou_]/, '')
  end

  def children?
    children.count.positive?
  end

  def full_key
    return "#{parent.full_key};#{self[:key]}" if parent.present?
    return "alt-#{self[:key]}" if parent.nil?
    self[:key]
  end

  def full_name
    "#{shortcut}-#{name}"
  end

  def self.render_tmux_keys(pwd = nil)
    text = "# extend tmux config\n"
    keys = Hotkey.with_type.where(hotkey_types: { name: 'tmux' })
    keys.each do |k|
      text += k.render_tmux + "\n"
    end
    text
  end

  def render_with_children(stack, adapter, options = {})
    default_stack = options.fetch(:default_stack, 'alt')
    recursive = options.fetch(:recursive, false)
    rendered = ''
    if children.count.zero?
      return adapter.render_standalone(default_stack, self) if stack.nil?
      return adapter.render_leaf(stack, self)
    else
      stack = default_stack if stack.nil?
      if recursive
        rendered += adapter.render_branch(stack, self)
      else
        stack += adapter.render_branch(stack, self)
        children.each do |c|
          rendered += c.render_with_children(stack, adapter)
        end
      end
      rendered += adapter.render_branch_tail(stack, self)
    end
    rendered
  end

  def render(type = 'shell')
    return render_tmux if type == 'tmux'
    return if hotkey_type.nil? || hotkey_type.name != 'shell'
    newline = ""
    newline = "^M" if executes
    "bindkey -s '#{key}' '#{command}#{newline}' ##{id}"
  end

  def render_tmux
    newline = ''
    newline = ' Enter' if executes && command.include?('send-keys')
    "bind -n #{key} #{command}#{newline}"
  end

  def self.create_window_manager_hotkey_from_raw(name, raw_hotkey, category, path, global_options)
    wm_type = HotkeyType.find_by(name: 'window_manager')
    keys, command = Util::parse_key_value(raw_hotkey)
    keys = keys.split(',')
    found_parent, hotkey_key = parse_from_keys(keys, wm_type)
    return 'duplicate key!' if check_for_duplicate(found_parent, hotkey_key)
    hk = Hotkey.new(name: name, key: hotkey_key, command: command.strip, location: Location.find_or_create_from_path(path), parent: found_parent, hotkey_type: wm_type)
    hk.apply_global_options(global_options)
    hk.executes = true
    if category.present?
      category.split(' ').each do |cat|
        hk.categories << Category.find_or_create_by(name: cat)
      end
    end
    hk.save
    'key added..'
  end

  def self.check_for_duplicate(parent, key)
    found = Hotkey.find_by(key: key, parent_id: parent)
    found.present?
  end

  def self.parse_from_keys(keys, type)
    if keys.count == 1
      found_parent = nil
      hotkey_key = keys[0].strip
    else
      parent = nil
      keys[0..-2].each do |key|
        found_parent = Hotkey.find_by(key: key.strip, parent_id: parent)
        found_parent = Hotkey.create(key: key.strip, hotkey_type: type,
                                     parent_id: parent.id) if found_parent.nil?
        parent = found_parent
      end
      hotkey_key = keys.last.strip
    end
    [parent, hotkey_key]
  end

  def self.create_tmux_hotkey_from_raw(name, raw_hotkey, category, path, is_command)
    tmux_type = HotkeyType.find_or_create_by(name: 'tmux')
    key, command = Util::parse_key_value(raw_hotkey)
    command = "send-keys \"#{command}\"" unless is_command
    hk = Hotkey.new(name: name, key: key.strip, command: command.strip, location: Location.find_or_create_from_path(path), parent: nil, hotkey_type:  tmux_type)
    hk.executes = true
    if category.present?
      category.split(' ').each do |cat|
        hk.categories << Category.find_or_create_by(name: cat)
      end
    end
    hk.save
  end

  def self.create_from_raw(name, raw_hotkey, category, path, global_options)
    key = raw_hotkey[0]
    command = raw_hotkey[1..-1].join(' ')
    hk = Hotkey.new(name: name, key: key.strip, command: command.strip, location: Location.find_or_create_from_path(path))
    hk.apply_global_options(global_options)
    # TODO: shell is default for now
    hk.hotkey_type = HotkeyType.find_by(name: 'shell')
    # TODO: executes by default for now
    hk.executes = true
    if category.present?
      category.split(' ').each do |cat|
        hk.categories << Category.find_or_create_by(name: cat)
      end
    end
    hk.save
  end

  def to_s
    "#{name} (#{key} -> #{command})"
  end
end
