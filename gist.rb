#!/usr/bin/ruby

# Computes a "perceptual gist" as the average of multiple images
# of the same pattern. Pattern name must be provided by the user
# in CLI arguments or at runtime.
#
# Author::  Tristan Jahier
# Licence:: GPLv3

require 'opencv'
include OpenCV


# ////////////////////////////////////////////////////////////////
# Some configuration...

# Display gist in an OpenCV window ?
display_gist = true
# Remove the unreadable or corrupted images files ?
remove_bad_files = true


# ////////////////////////////////////////////////////////////////
# Compute perceptual gist

gist = CvMat.new 240, 320, :cv32f

# Ask user for parameters if not passed in arguments
puts "Pattern name to gistify?" unless ARGV.first
pattern = ARGV.first || STDIN.gets.chomp # Chomp to ensure compatibility with I/O methods

if ARGV.size == 1 # Only the pattern name has been given in args

  if Dir.exists? "img/raw/#{pattern}"

    # Scan the folder to retrieve filenames
    images = Dir.glob "img/raw/#{pattern}/*.jpg"

    # For each image
    images.each do |filename|
      image = begin
                CvMat.load filename, CV_LOAD_IMAGE_COLOR
              rescue Exception => e
                puts "Could not open or find the image file #{filename}."
              end

      # If image file is unreadable or corrupted, let's get rid of it
      if image == nil
        File.unlink filename if remove_bad_files
      else
        image = image.resize CvSize.new(320, 240)
        gist += image # Sum the image to the gist
      end
    end

    # Average the gist
    gist /= images.size

  else
    STDERR.puts "Directory img/raw/#{pattern} does not exists."
  end

  gist.save_image "img/gist/#{pattern}.gist.jpg"
  puts "-- Gist saved to img/gist/#{pattern}.gist.jpg."

  if display_gist
    window = GUI::Window.new("Gist #{pattern}") # Create a window for display.
    window.show(gist.to_8u) # Show our image inside it.
    GUI::wait_key # Wait for a keystroke in the window.
  end
end
