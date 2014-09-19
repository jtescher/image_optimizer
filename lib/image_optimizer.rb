require 'image_optimizer/version'
require 'image_optimizer/shell'
require 'image_optimizer/image_optimizer_base'
require 'image_optimizer/jpeg_optimizer'
require 'image_optimizer/png_optimizer'

class ImageOptimizer
  include Shell

  attr_reader :path, :options

  def initialize(path, options = {})
    @path    = path
    @options = options
  end

  def optimize
    options = self.options.merge(:identify => format)
    JPEGOptimizer.new(path, options).optimize
    PNGOptimizer.new(path, options).optimize
  end

  def format
    if options[:identify]
      if self.class.identify_present?
        match = run_command("identify -ping#{quiet} #{path}").match(/PNG|JPG|TIFF|GIF|JPEG/)
        if match
          return match[0].downcase
        end
      else
        warn 'Attempting to retrieve image format without identify installed. Using file name extension instead...'
      end
    end
    nil
  end

  def quiet
    if self.class.image_magick?
      ' -quiet'
    end
  end

  class << self
    def image_magick?
      @image_magick = !!which('mogrify')
    end

    def identify_present?
      @identify ||= !!which('identify')
    end
  end
end
