#!/usr/bin/env ruby
require 'pty'
require 'pry'
require 'ostruct'
require 'redis'
require 'httparty'

EXTEND_URL = "http://localhost:3030"
KEY = "extend_activity_client"

class ActivityClient
  attr_accessor :node_names
  def initialize
    @node_names = {}
  end

  def start
    start_idle_checker
    subscribe
  end

  def active_id
    id = `xdotool getactivewindow`.strip
    sprintf("0x%.8X", id.to_i).downcase
  end

  def show_label
    name = node_name_for(active_id)
    `rofi -e #{name}`
  end

  def output_current
    name = node_name_for(active_id)
    puts name
  end

  def destroy_all
    Redis.current.scan_each(match: 'extend_activity_client:*') do |key|
      Redis.current.del(key)
    end
  end

  def destroy_label
    Redis.current.del("#{KEY}:#{active_id}")
  end

  def node_name_for(id)
    Redis.current.get("#{KEY}:#{id}")
  end

  def node_name_is(id, name)
    Redis.current.set("#{KEY}:#{id}", name)
  end

  def start_idle_checker
    @idle_pid = spawn("ruby idle_checker.rb")
    puts "stared idle checker with pid: #{@idle_pid}"
  end

  def subscribe
    cmd = "bspc subscribe all"
    begin
      PTY.spawn( cmd ) do |stdout, stdin, pid|
        begin
          # Do stuff with the output here. Just printing to show it works
          stdout.each { |line| parse_events(line) }
        rescue Errno::EIO
          puts "Errno:EIO error, but this probably just means " +
              "that the process has finished giving output"
        end
      end
    rescue PTY::ChildExited
      puts "The child process exited!"
    end
  end

  def parse_events(line)
    if line.start_with?("node_focus")
      details = node_details(line.split.last)
      return if details.nil? || details.name.nil?
      HTTParty.post(url_for(:activities), body: { activity: details.to_h })
      # HTTParty.post(ACTIVITY_URL, body: { activity: details.to_h })
      print "."
    end
  end

  def url_for(name)
    "#{EXTEND_URL}/#{name}.json"
  end

  def gen_newline_list_of_groups(activity)
    groups = HTTParty.get(url_for(:activity_groups), query: { activity: activity.to_h })
    groups.reject { |g| g['name'].nil? }.map { |g| g['name'] }.join("\n")
  end

  def retrieve_or_ask_for_name_of_node(id, title)
    node_name = node_name_for(id)
    if node_name.nil?
      node_name = `echo -e "#{gen_newline_list_of_groups(title)}" | rofi -dmenu`
      # node_name = `zenity --entry --text "name this activity"`
      return nil if node_name.strip.empty?
      node_name_is(id, node_name.strip!)
    end
    node_name
  end

  def should_ignore?(details)
    to_ignore = ["dialog", "image properties", "select image file"]
    to_ignore.each do |ignored|
      if details.application.downcase.include?(ignored) ||
         details.title.downcase.include?(ignored)
        return true
      end
    end
    false
  end

  def load_x_info(node_id)
    info = {}
    `xwininfo -id #{node_id}`.split("\n").each do |row|
      fields = row.split(':')
      if fields.count > 1
        info[fields[0].downcase.strip] = fields[1].strip
      end
    end
    info['area'] = info['height'].to_i * info['width'].to_i
    info
  end

  def node_relevant?(node_id, details)
    return false if should_ignore?(details)

    x_info = load_x_info(node_id)
    return false if x_info['area'] < 700 * 700

    ignored = File.readlines("#{ENV['extend_path']}/ignored_titles").map(&:strip)
    return false if ignored.include?(details.title)

    true
  end

  def node_details(node_id)
    node_id = node_id.downcase
    nodes = `wmctrl -lx`
    nodes.split("\n").each do |line|
      cols = line.split
      next if node_id != cols[0].downcase

      details = OpenStruct.new(application: cols[2], host: cols[3], title: cols[4..-1].join(' '))
      if !node_relevant?(node_id, details)
        return OpenStruct.new(name: nil, application: nil, title: nil)
      end

      details.name = retrieve_or_ask_for_name_of_node(cols[0], details)
      return nil if details.name.nil?

      return details
    end
    OpenStruct.new(name: nil, application: nil, title: nil)
  end

end

client = ActivityClient.new
if ARGV.count == 0
  client.start
elsif ARGV[0] == 'show'
  client.show_label
elsif ARGV[0] == 'output_current'
  client.output_current
elsif ARGV[0] == 'destroy'
  client.destroy_label
elsif ARGV[0] == 'destroy_all'
  client.destroy_all
end
