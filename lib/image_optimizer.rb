require "image_optimizer/version"
require "image_optimizer/jpeg_optimizer"
require "image_optimizer/png_optimizer"

class ImageOptimizer
  attr_reader :path
  attr_reader :quality

  def initialize(path, quality=-1)
    @path = path
    @quality = quality
  end

  def optimize
    JPEGOptimizer.new(path, quality).optimize
    PNGOptimizer.new(path).optimize
  end
end