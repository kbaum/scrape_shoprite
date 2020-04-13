#!/usr/bin/env ruby

# frozen_string_literal: true

require 'nokogiri'

file = ARGV[0]
if file.nil?
  "Please pass a file"
  exit 1
end
puts "Checking file #{file}"
doc = File.open(file) { |f| Nokogiri::HTML(f) }
elements = doc.css('.timeslotPicker__day .timeslotPicker__cell').reject do |elem|
  elem.at_css('button.timeslotPicker__timeslotButton').text.include?('Sold Out')
end

if elements.any?
  puts 'Found a time slot'
  exit 0
else
  puts 'No timeslots available'
  exit 1
end
