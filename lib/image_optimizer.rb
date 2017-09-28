require 'image_optimizer/version'
require 'image_optimizer/shell'
require 'image_optimizer/image_optimizer_base'
require 'image_optimizer/jpeg_optimizer'
require 'image_optimizer/png_optimizer'
require 'image_optimizer/gif_optimizer'
require 'image_optimizer/pngquant_optimizer'

class ImageOptimizer
  include Shell

  # Allow the +quiet+ flag to be set globally.
  @@quiet = false
  def self.quiet
    @@quiet
  end
  def self.quiet=(value)
    @@quiet = value
  end

  attr_reader :path, :options
  def initialize(path, options = {})
    @path    = path
    @options = options
  end

  def optimize
    identify_format if options[:identify]
    JPEGOptimizer.new(path, options).optimize
    PNGOptimizer.new(path, options).optimize
    PNGQuantOptimizer.new(path, options).optimize
    GIFOptimizer.new(path, options).optimize
  end

private

  def identify_format
    if identify_bin?
      match = run_command("#{identify_bin} -ping#{quiet} #{path}").match(/PNG|JPG|TIFF|GIF|JPEG/)
      if match
        options[:identified_format] = match[0].downcase
      end
    else
      warn 'Attempting to retrieve image format without identify installed. Using file name extension instead...'
    end
  end

  def quiet
    ' -quiet' if image_magick?
  end

  def image_magick?
    !!which('mogrify')
  end

  def identify_bin?
    !!identify_bin
  end

  def identify_bin
    ENV['IDENTIFY_BIN'] || which('identify')
  end

end
