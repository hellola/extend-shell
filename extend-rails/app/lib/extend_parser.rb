require 'gli'
require_relative 'extend_shell'

# This ugliness is due to using GLI over an EventMachine connection
$original_stderr = $stderr
$original_stdout = $stdout
$stdout = StringIO.new
$stderr = StringIO.new
$stdout.sync = true
$stderr.sync = true

include GLI::App
GLI::Commands::Help.skips_around = false

$result=""
$command=""
$extend_path=ENV['extend_path']

program_desc 'Describe your application here'

around do |global_options,command,options,arguments,code|
  # $result += "around call...#{global_options}, #{command}"
  code.call
  $result += $stderr.string
  $result += $stdout.string
end


version ExtendShell::VERSION

subcommand_option_handling :normal
arguments :strict

desc 'OS Specific'
arg_name 'os-only'
switch [:s, :'os-only']
default_value false

desc 'The current path'
arg_name 'path'
default_value ''
flag [:p,:path]


desc 'Sync files'
command :sync do |c|
  c.desc 'writes alias and function files'
  c.action do |global_options, options, args|
    pwd = global_options[:path]
    puts "sync called from: #{pwd}"
    File.write("#{$extend_path}/extend.zsh", Util.render_all(pwd))
    File.write("#{$extend_path}/extend_search", Util.render_command_search(pwd))
    File.write("#{$extend_path}/extend_wm_search", Util.render_wm_key_search)
    File.write("#{$extend_path}/keys.yml", Chord.render_keys(pwd))
    File.write("#{$extend_path}/radmenu.json", Hotkey.render_window_menu_keys(pwd))
    File.write("#{$extend_path}/window_manager.conf", Hotkey.render_window_keys(pwd))
    File.write("#{$extend_path}/tmux.conf", Hotkey.render_tmux_keys(pwd))
    File.write("#{$extend_path}/hist", History.load_all(path: pwd).join("\n") + "\n")
    File.write("#{$extend_path}/startup", Startup.load_all.join("\n") + "\n")
    FileUtils.chmod('+x', "#{$extend_path}/startup")
    $result = 'done'
  end
end

desc 'Startup'
command :startup do |c|
  c.desc 'adds a startup action'
  c.arg_name 'startup'
  c.command :add do |add|
    add.action do |global_options, options, args|
      als = args[0..-1].join(' ')
      cat = nil
      path = nil
      Startup.create_from_raw(als, cat, path, global_options)
      $result = "added alias"

    end
  end
  c.desc 'executes startup actions'
  c.command :exec do |exec|
    exec.action do |global_options, options, args|
      if Startup.should_run?
        $result = "STARTUP:\n"
        Startup.all.order(:order).each do |startup| 
          $result += "#{startup.name}\n"
          startup.execute_sync
          sleep 1
        end
        $result += 'DONE'
      else
        $result = 'ALREADY RAN STARTUP'
      end
    end
  end
end

## aliases

desc 'Manages aliases'
arg_name 'type type_options'
command :alias do |c|
  c.desc 'adds an alias'
  c.arg_name 'alias category'
  c.command :'add-path' do |add|
    add.action do |global_options, options, args|
      als = args[0..-1]
      # TODO: move cat to flag or something?
      # cat = args[1] if args.length > 1
      cat = nil
      path = Dir.pwd
      Alias.create_from_raw(als, cat, path, global_options)
      $result = "added alias"
    end
  end

  c.desc 'adds an alias'
  c.arg_name 'alias category'
  c.command :add do |add|
    add.desc 'whether to be path specific'
    add.switch [:o,:only]
    add.action do |global_options, options, args|
      als = args[0..-1].join(' ')
      #cat = args[1] if args.length > 1
      # TODO: move cat to a flag or something..
      cat = nil
      path = nil
      # TODO: this pwd wont work with server arch
      path = Util::sanitize_path(global_options[:path]) if options[:only]
      Alias.create_from_raw(als, cat, path, global_options)
      $result = "added alias"
    end
  end

  c.desc 'list the aliases for an optional category'
  c.command :ls do |list|
    list.action do |global_options,options,args|
      categories = args[0] || nil
      $result="aliases:\n" + Alias.list_all(categories).join("\n")
    end
  end

  c.desc 'removes a specific alias for an optional category'
  c.arg_name 'alias name'
  c.command :rm do |rm|
    rm.action do |global_options,options,args|
      name = args[0] || nil
      raise 'no alias name provided' if name.nil?
      als = Alias.where(name: name)
      Alias.destroy_with_shortcut(name)
      if als.count > 0
        Util::add_to_destruction(als.first.destruct)
      end
      als.destroy_all
      $result = "#{name} alias removed"
    end
  end
end

## functions

desc 'Manages functiones'
arg_name 'type type_options'
command :func do |c|
  c.desc 'adds an function'
  c.arg_name 'function category'
  c.command :add do |add|
    add.desc 'whether to be path specific'
    add.switch [:o,:only]
    add.action do |global_options,options,args|
      func = args.join(' ')
      # cat = args[1] if args.length > 1
      cat = nil
      path = Util::sanitize_path(global_options[:path]) if options[:only]
      Function.create_from_raw(func, cat, path, global_options)
      $result = "added function"
    end
  end

  c.desc 'list the functiones for an optional category'
  c.command :ls do |list|
    list.action do |global_options, options,args|
      categories = args[0] || nil
      $result="functions:\n" + Function.list_all(categories).join("\n")
    end
  end

  c.desc 'removes a specific function for an optional category'
  c.arg_name 'function name'
  c.command :rm do |rm|
    rm.action do |global_options,options,args|
      name = args[0] || nil
      raise 'no function name provided' if name.nil?
      Function.where(name: name).destroy_all
      Function.destroy_with_shortcut(name)
      $result = "#{name} function removed"
    end
  end
end


# histories
desc 'Manages history'
arg_name 'history'
command :history do |c|

  c.desc 'adds a history entry'
  c.arg_name 'command ran'
  c.command :add do |add|
    add.action do |global_options,options,args|
      hist = args.join(' ')
      path = Util::sanitize_path(global_options[:path]) if options[:only]
      History.create_from_raw(hist, path, global_options)
      $result = "added history"
    end
  end

  c.desc 'list the histories for the current path'
  c.command :ls do |list|
    list.action do |global_options,options,args|
      $result = "path history:" + History.list_all(Dir.pwd).join("\n")
    end
  end

  c.desc 'load the histories for the current path'
  c.command :ld do |load|
    load.action do |global_options,options,args|
      $result = History.load_all(Dir.pwd).join("\n")
    end
  end
end

## hotkeys

desc 'Manages hotkeys'
arg_name 'type type_options'
command :key do |c|
  c.desc 'executes a hotkey'
  c.arg_name 'hotkey name'
  c.command 'exec' do |exec|
    exec.action do |global_options, options, args|
      name = args[0]
      found = Hotkey.all.select { |n| n.full_name == name }
      return if found.nil?
      chosen = found.first
      if found.count > 1
        found = found.select do |k|
          k.operating_system == OperatingSystem.find_or_create_for_current
        end
        chosen = found.first if found.count.positive?
      end
      chosen.execute if chosen.present?
      $result = 'executed'
    end
  end

  c.desc 'adds a window manager hotkey <name> hotkey,hotkey_chord=action'
  c.arg_name 'hotkey category'
  c.command 'add-wm' do |add|
    add.desc 'whether to be only for the current path'
    add.switch [:o, :only]
    add.action do |global_options, options, args|
      name = args[0]
      hotkey = args[1..-1].join(' ')
      # cat = args[1] if args.length > 1
      cat = nil
      path = Util::sanitize_path(global_options[:path]) if options[:only]
      $result = Hotkey.create_window_manager_hotkey_from_raw(name, hotkey, cat, path, global_options)
    end
  end

  c.desc 'adds a tmux hotkey <name> hotkey=action'
  c.arg_name 'hotkey category'
  c.command 'add-tmux' do |add|
    add.desc 'whether it is a tmux command (otherwise send-keys are used)'
    add.switch [:c, :command]
    add.desc 'whether to be only for the current path'
    add.switch [:o,:only]
    add.action do |global_options,options,args|
      name = args[0]
      hotkey = args[1..-1].join(' ')
      # cat = args[1] if args.length > 1
      cat = nil
      path = Util::sanitize_path(global_options[:path]) if options[:only]
      is_command = options[:command]
      Hotkey.create_tmux_hotkey_from_raw(name, hotkey, cat, path, is_command)
      $result = "added hotkey"
    end
  end

  c.desc 'adds a hotkey <name> hotkey=action'
  c.arg_name 'hotkey category'
  c.command :add do |add|
    add.desc 'whether to be only for the current path'
    add.switch [:o,:only]
    add.action do |global_options,options,args|
      name = args[0]
      hotkey = args[1..-1]
      # cat = args[1] if args.length > 1
      cat = nil
      path = Util::sanitize_path(global_options[:path]) if options[:only]
      Hotkey.create_from_raw(name, hotkey, cat, path, global_options)
      $result = "added hotkey"
    end
  end

  c.desc 'list the hotkeyes for an optional category'
  c.command :ls do |list|
    list.action do |global_options,options,args|
      categories = args[0] || nil
      $result="hotkeys:\n" + Hotkey.list_all(categories).join("\n")
    end
  end

  c.desc 'removes a specific hotkey for an optional category'
  c.arg_name 'hotkey name'
  c.command :rm do |rm|
    rm.action do |global_options,options,args|
      name = args[0] || nil
      raise 'no hotkey name provided' if name.nil?
      found = Hotkey.where(name: name)
      if found.nil?
        found = Hotkey.where('command like ?',"%#{name}%" )
      end
      found.destroy_all
      $result = "#{name} hotkey removed"
    end
  end
end

## environments

desc 'Manages environment values'
arg_name 'type type_options'
command :env do |c|
  c.desc 'adds a environment'
  c.arg_name 'environment category'
  c.command :add do |add|
    add.desc 'whether to be path specific'
    add.switch [:o,:only]
    add.action do |global_options,options,args|
      environment = args[0..-1].join(' ')
      # cat = args[1] if args.length > 1
      cat = nil
      path = Util::sanitize_path(global_options[:path]) if options[:only]
      Environment.create_from_raw(environment, cat, path, global_options)
      $result = "added environment"
    end
  end

  c.desc 'list the environmentes for an optional category'
  c.command :ls do |list|
    list.action do |global_options,options,args|
      categories = args[0] || nil
      $result="environments:\n" + Environment.list_all(categories).join("\n")
    end
  end

  c.desc 'removes a specific environment for an optional category'
  c.arg_name 'environment name'
  c.command :rm do |rm|
    rm.action do |global_options,options,args|
      name = args[0] || nil
      raise 'no environment name provided' if name.nil?
      Environment.where('command like ?',"%#{name}%" ).destroy_all
      $result = "#{name} environment removed"
    end
  end
end

pre do |global,command,options,args|
  true
end

post do |global,command,options,args|
  # Post logic here
  # Use skips_post before a command to skip this
  # block on that command only
end

on_error do |exception|
  $result += exception.to_s
  # Error logic here
  # return false to skip default error handling
  true
end

# make the run method accessible externally
RUN=self.method(:run)
