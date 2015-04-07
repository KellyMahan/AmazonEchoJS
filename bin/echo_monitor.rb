#!/usr/bin/env ruby

require 'rubygems'
require 'AmazonEchoJS'

if ARGV.count!=3
  puts "to run echo_monitor you must provide the username, password, and callback url"
  puts "echo_monitor email@domain.com 1234567890 'http://localhost:4567/command'"
  exit
end
echo = AmazonEchoJS::Echo.new(ARGV[0], ARGV[1], ARGV[2])
puts "Starting up monitor"
echo.keep_alive