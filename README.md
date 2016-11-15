# ImageOptimizer

This gem allows you to simply optimize images via jpegoptim or OptiPNG.

Tested against ruby 2.0.x, 2.1.x, 2.2.x, 2.3.x, and ruby-head

[![Build Status](https://secure.travis-ci.org/jtescher/image_optimizer.png)]
(http://travis-ci.org/jtescher/image_optimizer)
[![Dependency Status](https://gemnasium.com/jtescher/image_optimizer.png)]
(https://gemnasium.com/jtescher/image_optimizer)
[![Code Climate](https://codeclimate.com/github/jtescher/image_optimizer.png)]
(https://codeclimate.com/github/jtescher/image_optimizer)
[![Coverage Status](https://coveralls.io/repos/jtescher/image_optimizer/badge.png)]
(https://coveralls.io/r/jtescher/image_optimizer)
[![Gem Version](https://badge.fury.io/rb/image_optimizer.png)](http://badge.fury.io/rb/image_optimizer)

## Installation

##### This gem uses the following utilities for optimizing images:

1. jpegoptim, which can be installed from [freecode.com](http://freecode.com/projects/jpegoptim)

2. OptiPNG, which can be installed from [sourceforge.net](http://optipng.sourceforge.net/)

3. Gifsicle, which can be installed from [www.lcdf.org/gifsicle/](https://www.lcdf.org/gifsicle/)

4. Pngquant, which can be installed from [pngquant.org]https://pngquant.org/

Or install the utilities via homebrew:

```bash
$ brew install optipng jpegoptim gifsicle pngquant
```

Then add this line to your application's Gemfile:

    gem 'image_optimizer'

And then execute:

```bash
$ bundle
```   

Or install it yourself as:
```bash
$ gem install image_optimizer
```

## Usage

#### Optimize PNG formats:

OptiPNG is a PNG optimizer that recompresses image files to a smaller size without losing any information and
performs PNG integrity checks and corrections.

```ruby
ImageOptimizer.new('path/to/file.png').optimize
```

Pngquant is a command-line utility and a library for lossy compression of PNG images.
The conversion reduces file sizes significantly (often as much as 70%) and preserves full alpha transparency. Generated images are compatible with all modern web browsers, and have better fallback in IE6 than 24-bit PNGs.

```ruby
PNGQuantOptimizer.new('path/to/file.png').optimize
```

#### Optimize JPEG formats:

jpegoptim provides lossless optimization for JPEG files based on optimizing the Huffman tables.
All jpegs will be progressively optimized for a better web experience

```ruby
ImageOptimizer.new('path/to/file.jpg').optimize
```

#### Optimize GIF formats:

Gifsicle is a command-line tool for creating, editing, and getting information about GIF images and animations. This stores only the changed portion of each frame, and can radically shrink your GIFs. You can also use transparency to make them even smaller. Gifsicle’s optimizer is pretty powerful, and usually reduces animations to within a couple bytes of the best commercial optimizers.

```ruby
ImageOptimizer.new('path/to/file.gif').optimize
```

## Optimization Options

##### Quiet optimization

To have optimization performed in quiet mode without logging progress, an optional `quiet` parameter may be passed.
Default is false.

```ruby
ImageOptimizer.new('path/to/file.jpg', quiet: true).optimize
```

##### Lossy JPEG optimization

Pass an optional `quality` parameter to target a specific lossy JPG quality level (0-100), default is lossless
optimization. PNGs will ignore the quality setting.

```ruby
ImageOptimizer.new('path/to/file.jpg', quality: 80).optimize
```

##### Custom PNG optimization quality

By default, `optipng` is called with the `-o7` flag, which controls the level of
optimization. This default level generates the most optimized results, at the
expense of very high execution times, so you may want to lower it if your server
can't handle it.

You can pass an optional `level` parameter to change this value. the JPEG
optimizer will ignore the value.

```ruby
ImageOptimizer.new('path/to/file.png', level: 3).optimize
```

Pngquant is called with the '--skip-if-larger', '--speed 1','--force', '--verbose', '--ext .png' flags.
This runs pngquant on all png files in the current directory and subdirectory and optimized them in place. Flag '--skip-if-larger' skips images which are  smaller. Flag '--ext .png' set custom extension (suffix) for output filename. By default -or8.png or -fs8.png is used.


##### Don't Remove metadata from PNG

By default, `optipng` is called with the `-strip all` flag, which removes all the
level of metadata. This default generates the most optimized results.

You can skip removing the meta data by changing the `strip_metadata` parameter to
`false`. the JPEG optimizer will ignore the value.

```ruby
ImageOptimizer.new('path/to/file.png', strip_metadata: false).optimize
```

##### Custom GIF optimization quality

By default, `gifsicle` is called with the `-O1` flag, which controls the level of
optimization. It stores only the changed portion of each image. Other allowed flag are `-O2` (Also uses transparency to shrink the file further), `-O3` (Try several optimization methods , usually slower, sometimes better results)

You can pass an optional `level` parameter to change this value. the JPEG
optimizer will ignore the value.

```ruby
ImageOptimizer.new('path/to/file.gif', level: 3).optimize
```

##### Use identify

Pass an optional `identify` parameter to identify file types using ImageMagick or GraphicsMagick `identify`
instead of the filename extension, default is false.

```ruby
ImageOptimizer.new('path/to/file.jpg', identify: true).optimize
```

## Set bin directories

Optionally set binary directories with the `OPTIPNG_BIN`, `JPEGOPTIM_BIN` and `IDENTIFY_BIN` environment variables.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
