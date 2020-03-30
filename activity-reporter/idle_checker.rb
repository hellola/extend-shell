#!/usr/bin/env ruby

require 'httparty'
require 'pry'

ACTIVITY_URL = "http://localhost:3030/activities.json"
POLL_INTERVAL=40

def post_idle
  puts "!!idle"
  result = HTTParty.post(ACTIVITY_URL,
                         body: {
                           activity: {
                             name: "idle",
                             host: `hostname`.strip,
                             application: "idle",
                             title: "idle",
                           }
                         })
end

loop do
  idle_for  = `xprintidle`
  puts "checking: #{idle_for}"
  if idle_for.to_i / 1000 > 30
    post_idle
  end
  sleep POLL_INTERVAL
end

