require 'image_optimizer/version'
require 'image_optimizer/jpeg_optimizer'
require 'image_optimizer/png_optimizer'

class ImageOptimizer
  attr_reader :path, :options

  def initialize(path, options = {})
    @path    = path
    @options = options
  end

  def optimize
    JPEGOptimizer.new(path, options).optimize
    PNGOptimizer.new(path, options).optimize
  end
end
