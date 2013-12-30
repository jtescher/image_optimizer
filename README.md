# ImageOptimizer

This gem allows you to simply optimize images via jpegoptim or OptiPNG.

Tested against ruby 1.8.7, 1.9.2, 1.9.3, 2.0.0, 2.1.0, ruby-head, jruby-18mode, jruby-19mode, jruby-head, rbx-2.1.0,
rbx-2.2.0, and ree

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

Or install the utilities via homebrew: 

```bash
$ brew install optipng jpegoptim
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

#### Optimize PNG or GIF formats:

OptiPNG is a PNG optimizer that recompresses image files to a smaller size without losing any information and
performs PNG integrity checks and corrections.

```ruby
ImageOptimizer.new('path/to/file.png').optimize
```

#### Optimize JPEG formats:

jpegoptim provides lossless optimization for JPEG files based on optimizing the Huffman tables.
All jpegs will be progressively optimized for a better web experience

```ruby
ImageOptimizer.new('path/to/file.jpg').optimize
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


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
