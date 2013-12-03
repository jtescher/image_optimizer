# ImageOptimizer

This gem allows you to simply optimize images via jpegoptim or OptiPNG.

Tested against ruby 1.8.7, 1.9.2, 1.9.3, ruby-head, jruby-18mode, jruby-19mode, jruby-head, rbx-18mode, rbx-19mode, and
ree

[![Build Status](https://secure.travis-ci.org/jtescher/image_optimizer.png)]
(http://travis-ci.org/jtescher/image_optimizer)
[![Dependency Status](https://gemnasium.com/jtescher/image_optimizer.png)]
(https://gemnasium.com/jtescher/image_optimizer)
[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/jtescher/image_optimizer)
[![Coverage Status](https://coveralls.io/repos/jtescher/image_optimizer/badge.png)]
(https://coveralls.io/r/jtescher/image_optimizer)

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

jpegoptim provides lossless optimization for JPEG files based on optimizing the Huffman tables. all jpegs will be progressively optimized for a better web experience

```ruby
ImageOptimizer.new('path/to/file.jpg').optimize
```

##### Lossy JPEG optimization

Pass an optional 'quality' parameter to target a specific JPG quality level (0-100), or pass -1 for lossless optimization. PNGs will ignore the quality setting

```ruby
ImageOptimizer.new('path/to/file.jpg', 80).optimize
```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
