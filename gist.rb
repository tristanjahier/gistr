#!/usr/bin/ruby

require 'opencv'
include OpenCV

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
                puts "Could not open or find the image file img/raw/#{pattern}/#{filename}."
              end
      image = image.resize CvSize.new(320, 240)
      gist += image # Sum the image to the gist
    end

    # Average the gist
    gist /= images.size

  else
    STDERR.puts "Directory img/raw/#{pattern} does not exists."
  end

  gist.save_image "img/gist/#{pattern}.gist.jpg"

  window = GUI::Window.new("Gist #{pattern}") # Create a window for display.
  window.show(gist.to_8u) # Show our image inside it.
  GUI::wait_key # Wait for a keystroke in the window.
end

