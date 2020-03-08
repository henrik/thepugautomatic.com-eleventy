#!/usr/bin/env ruby
# By Henrik Nyh 2007-09-11.
# Free to modify and redistribute with due credit.


# Change these:

USERNAME = 'frank'
PASSWORD = 'sesame'

REPLACE_FROM = 'myoldsite.com'
REPLACE_UNTO = 'mynewsite.com'


# Leave these alone unless you know what you're doing:

require 'rubygems'
require 'livejournal/login'
require 'livejournal/entry'

# So the livejournal gem doesn't choke:
# http://henrik.nyh.se/2007/04/ruby-livejournal-batch-private#comments
LiveJournal::Entry::KNOWN_EXTRA_PROPS << "used_rte"

puts "Logging in..."
user = LiveJournal::User.new(USERNAME, PASSWORD)
login = LiveJournal::Request::Login.new(user)
login.run
puts "Login response:"
login.dumpresponse

puts "Getting entries..."
entries = LiveJournal::Request::GetEvents.new(user, :recent => -1).run.values
entries = entries.sort_by { |e| e.time }

puts "Processing entries..."
entries.each do |e|
	puts "#{e.time} #{e.subject}"
	e.event = e.event.gsub(REPLACE_FROM, REPLACE_UNTO)
	LiveJournal::Request::EditEvent.new(user, e).run
	puts e.event
end

puts "All done."
