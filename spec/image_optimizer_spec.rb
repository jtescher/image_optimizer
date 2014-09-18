require 'spec_helper'

describe ImageOptimizer do
  describe '#optimize' do
    it 'delegates to jpeg and png optimizers' do
      expect_any_instance_of(ImageOptimizer::JPEGOptimizer).to receive(:optimize)
      expect_any_instance_of(ImageOptimizer::PNGOptimizer).to receive(:optimize)
      ImageOptimizer.new('/path/to/image.jpg').optimize
    end
  end
end
