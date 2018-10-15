module Executable
  extend ActiveSupport::Concern
  def load_executable(exec_id)
    return if exec_id.nil?
    type, id = parse_exec_id(exec_id)
    return OpenStruct.new(command: id, raw: true) if type.nil?
    type.find(id)
  end
  module_function :load_executable

  def parse_exec_id(exec_id)
    type_code, id = exec_id.split('-')
    type = case type_code
           when 'h'
             Hotkey
           when 'f'
             Function
           when 'a'
             Alias
           when 'r'
             :raw
           end
    if type == :raw
      return [nil, id]
    end
    [type, id.to_i]
  end
  module_function :parse_exec_id


  included do
    def execute_sync
      `#{command}`
    end
    def execute
      fork do
        exec(command)
      end
    end
  end
end
