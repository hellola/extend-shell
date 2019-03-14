require 'yaml'
require 'extend_parser'

module ExtendHooks
  def post_init
  end

  def receive_data data
    if data.strip =~ /(extend-exit)$/i
      send_data ({ result: 'exited', command: 'exit' }).to_json
      close_connection_after_writing
      EventMachine.stop
    else
      puts "recieved command: #{data}"
      args = data.split(' ')
      RUN.call(args)
      send_data ({ result: $result, command: $command }).to_json
      close_connection_after_writing
    end
  end
end
