#!/usr/bin/ruby

require 'flickraw'
require 'net/http'
require 'fileutils'

# Flickr application auth
FlickRaw.api_key = "app_api_key"
FlickRaw.shared_secret = "app_shared_secret"

# User auth
flickr.access_token = "user_access_token"
flickr.access_secret = "user_access_secret"

# Authentication
login = flickr.test.login
puts "-- Authenticated as #{login.username}"

# Display photo licenses
# licenses = flickr.photos.licenses.getInfo
# puts "\nAvailable photo licenses:"
# licenses.each do |l|
#   puts "#{l.id}: #{l.name}"
# end

# Ask user for parameters if not passed in arguments
puts "Search keywords?" unless ARGV.first
keywords = ARGV.first || STDIN.gets

puts "Pattern name? (will be used as output folder)" unless ARGV[1]
pattern = ARGV[1] || STDIN.gets.chomp # Chomp to ensure compatibility with I/O methods

puts "Number of pictures to download?" unless ARGV[2]
pictures_number = (ARGV[2] || STDIN.gets).to_i

# Search for no copyright restrictions pictures only
photos = flickr.photos.search text: keywords, sort: :relevance #,license: 7

# Changes the current directory to raw images folder
FileUtils.cd 'img/raw' do

  # Try creating the directory unless it already exists
  begin
    FileUtils.mkdir pattern
  rescue Errno::EEXIST => e
    # Nothing to do...
  end

  # Then download the pictures
  count = 0
  photos.each do |p|
    break if count >= pictures_number
    url = "http://farm#{p.farm}.static.flickr.com/#{p.server}/#{p.id}_#{p.secret}.jpg"
    puts "Retrieving: \"#{p.title}\"\n  #{url}"
    Net::HTTP.start("farm#{p.farm}.static.flickr.com") do |http|
      resp = http.get("/#{p.server}/#{p.id}_#{p.secret}.jpg")
      open("#{pattern}/#{p.id}_#{p.secret}.jpg", "wb") do |file|
        file.write(resp.body)
      end
    end
    count += 1
  end

  puts "-- #{count} photos downloaded in img/raw/#{pattern}."

end
