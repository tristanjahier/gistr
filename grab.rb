#!/usr/bin/ruby

# Connects to Flickr API, searches for images then downloads them.
# Keywords, pattern name & download limit must be provided by the user
# in CLI arguments or at runtime.
#
# Author::  Tristan Jahier
# Licence:: GPLv3

require 'flickraw'
require 'net/http'
require 'fileutils'
require 'yaml'


# ////////////////////////////////////////////////////////////////
# Loading configuration

if File.exists? 'config.yml'
  config = YAML.load File.read('config.yml')
else
  STDERR.puts "Configuration file 'config.yml' does not exist."
  exit
end


# ////////////////////////////////////////////////////////////////
# Authentication to Flickr API

begin
  FlickRaw.api_key       = config['flickr_auth']['app']['api_key']
  FlickRaw.shared_secret = config['flickr_auth']['app']['shared_secret']
  flickr.access_token    = config['flickr_auth']['user']['access_token']
  flickr.access_secret   = config['flickr_auth']['user']['access_secret']
  login = flickr.test.login
  puts "-- Authenticated as #{login.username}"
rescue FlickRaw::FailedResponse, FlickRaw::OAuthClient::FailedResponse => e
  puts "-- Error: failed authentication to Flickr API"
  puts "   Message: #{e.message}"
  exit
end


# ////////////////////////////////////////////////////////////////
# Ask user for parameters if not passed in arguments

puts "Search keywords?" unless ARGV.first
keywords = ARGV.first || STDIN.gets.chomp

puts "Pattern name? (will be used as output folder)" unless ARGV[1]
pattern = ARGV[1] || STDIN.gets.chomp # Chomp to ensure compatibility with I/O methods

puts "Number of pictures to download?" unless ARGV[2]
images_number = (ARGV[2] || STDIN.gets.chomp).to_i


# ////////////////////////////////////////////////////////////////
# Search images using Flick API

# Number of images already retrieved
count = 0

# Changes the current directory to raw images folder
FileUtils.cd 'img/raw' do

  # Try creating the directory unless it already exists
  begin
    FileUtils.mkdir pattern
  rescue Errno::EEXIST => e
    # Nothing to do...
  end

  # Handle results pagination
  images_per_page = 100
  pages_number = (images_number.to_f / images_per_page).ceil

  # Iterate through pages
  1.upto pages_number do |current_page|

    puts "\n----------------------------------------------------------------\n"
    puts "-- Search: \"#{keywords}\", page #{current_page}/#{pages_number}"
    puts "----------------------------------------------------------------\n"

    photos = flickr.photos.search text: keywords,
                                  sort: :relevance,
                                  per_page: images_per_page,
                                  page: current_page
                                  #,license: 7

    # Then download the pictures
    photos.each do |p|

      break if count >= images_number

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

  end

end

puts "-- #{count} photos downloaded in img/raw/#{pattern}."
