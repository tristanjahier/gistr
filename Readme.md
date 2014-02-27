# Gistr, a cute perceptual gist generator

*Created with fun by [Tristan Jahier](http://tristan-jahier.fr).*

## Compatibility

*(A least, as far as I know. It might be more or less...)*

- Ruby: `1.9.3`, `2.0.0`
- Flickraw: `0.9.7+`
- OpenCV: `2.4.7+`
- ruby-opencv: `0.0.7+`

## Requirements

## A Flickr application

First of all, to provide access to Flickr API, **you must have a Flickr account & an application with API credentials**.

## Flickraw

**Flickraw** is a wrapper for the Flickr API in Ruby. Gistr uses it to retrieve large sets of relevant pictures.

```gem install flickraw```

- Website: [http://hanklords.github.io/flickraw](http://hanklords.github.io/flickraw)
- Github repo: [https://github.com/hanklords/flickraw](https://github.com/hanklords/flickraw)

## OpenCV

**Open** source **C**omputer **V**ision is a library which provides loads of tools for manipulating images and matrices. If you do digital imaging, you should already have it. If not, you *really* should. Gistr uses it to compute the gist image.

You will find downloads and installation instructions at [http://opencv.org](http://opencv.org).

## ruby-opencv

**ruby-opencv** is a gem that provides bindings for the OpenCV library. It allows you to use OpenCV in a Ruby application.

Installation requires C/C++ compilation. Make sure you have installed the [Ruby Development Kit](https://github.com/oneclick/rubyinstaller/wiki/Development-Kit) and a C/C++ compiler like GCC.

Installation should be as simple as: ```gem install ruby-opencv```

**But!** ...on Windows, installation could be more tricky. You'll probably have to explicitly tell the path to find OpenCV headers and libraries.

Here is an example, assuming I made a standard OpenCV installation and I want to use **MinGW** compiler:

```gem install ruby-opencv -- --with-opencv-include=C:\opencv\build\include --with-opencv-lib=C:\opencv\build\x86\mingw\lib```

If you are using a shell that supports Unix-like paths (e.g. Git Bash), don't forget to replace every backslash `\` with a regular slash `/`, otherwise it won't work.

If installation process tells you:

> Building native extensions.  This could take a while...

and actually takes a while, this is a good omen.

- Github repo: [https://github.com/ruby-opencv/ruby-opencv](https://github.com/ruby-opencv/ruby-opencv)
- Documentation (hard to find out): [http://www.ruby-doc.org/gems/docs/o/opencv-0.0.7/OpenCV.html](http://www.ruby-doc.org/gems/docs/o/opencv-0.0.7/OpenCV.html) 

# Usage

## Folder tree

You must have this folder tree along with `grab.rb` and `gist.rb`, otherwise it won't work.

	- grab.rb
	- gist.rb
	- img/
	  - raw/
	  - gist/

`raw` contains pattern folders. `gist` contains computed gist images.

## Configuration file

In order to authenticate with Flickr API, **you must create a configuration file** named `config.yml` along with `grab.rb` and `gist.rb`:

	flickr_auth:
	  app:
		api_key: __my_api_key__
		shared_secret: __my_shared_secret__
	  user:
		access_token: __my_access_token__
		access_secret: __my_access_secret__

These credentials can be found in your Flickr account.

## Flickr grabber

Retrieves a set of photos from Flickr.

```ruby grab.rb <keywords> <pattern> <number>```

- *keywords*: used for the search on Flickr. If you want to use multiple keywords separated by spaces, surround it with `""`. e.g.: `"keyword1 kw2 kw3 ..."`
- *pattern*: name of the pattern of images you want to retrieve. The directory which will contain the images is named after it.
- *number*: maximum number of images that will be downloaded from Flickr.

## Gist generator

Computes a perceptual gist for a pattern of pictures.

```ruby gist.rb <pattern>```

- *pattern*: name of the pattern you want to compute a gist from. It is also the name of the directory that contains the images.

---

*That's all folks!*
