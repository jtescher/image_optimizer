require "image_optimizer/version"
require "image_optimizer/jpeg_optimizer"
require "image_optimizer/png_optimizer"

class ImageOptimizer
  attr_reader :path

  def initialize(path)
    @path = path
  end

  def optimize
    JPEGOptimizer.new(path).optimize
    PNGOptimizer.new(path).optimize
  end
end