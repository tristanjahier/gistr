# Gistr, a cute perceptual gist generator

*Created with fun by [Tristan Jahier](http://tristan-jahier.fr).*

## Compatibility

*(A least, as far as I know. It might be more or less...)*

- Ruby: `1.9.3`, `2.0.0`
- Flickraw: `0.9.7`
- OpenCV: `2.4.7`
- ruby-opencv: `0.0.7`

## Requirements

## Flickraw

**Flickraw** is a wrapper for the Flickr API in Ruby. In **Gistr**, it is used to retrieve large sets of relevant pictures.

```gem install flickraw```

- Website: [http://hanklords.github.io/flickraw](http://hanklords.github.io/flickraw)
- Github repo: [https://github.com/hanklords/flickraw](https://github.com/hanklords/flickraw)

## OpenCV

**Open** source **C**omputer **V**ision is a library which provides loads of tools for manipulating images and matrices. If you do digital imaging, you should already have it. If not, you *really* should. In **Gistr**, it is used to compute the gist image.

You will find downloads and installation instructions at [http://opencv.org](http://opencv.org).

## ruby-opencv

**ruby-opencv** is a gem that provides bindings for the OpenCV library. It allows you to use OpenCV in a Ruby application.

Installation requires C/C++ compilation. Make sure you have installed the [Ruby Development Kit](https://github.com/oneclick/rubyinstaller/wiki/Development-Kit).

```gem install ruby-opencv```

- Github repo: [https://github.com/ruby-opencv/ruby-opencv](https://github.com/ruby-opencv/ruby-opencv)
- Documentation (hard to find out): [http://www.ruby-doc.org/gems/docs/o/opencv-0.0.7/OpenCV.html](http://www.ruby-doc.org/gems/docs/o/opencv-0.0.7/OpenCV.html) 

# Usage

# Flickr grabber

Retrieves the set of photos from Flickr.

```ruby grab.rb <keywords> <pattern> <number>```

- *keywords*: TODO
- *pattern*: TODO
- *number*: TODO

# Gist generator

Computes a perceptual gist for a pattern of pictures.

```ruby gist.rb <pattern>```

- *pattern*: TODO
