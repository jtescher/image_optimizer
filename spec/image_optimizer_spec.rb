require 'spec_helper'

describe ImageOptimizer do
  describe '#optimize' do
    it 'delegates to jpeg and png optimizers' do
      ImageOptimizer::JPEGOptimizer.any_instance.should_receive(:optimize)
      ImageOptimizer::PNGOptimizer.any_instance.should_receive(:optimize)
      ImageOptimizer.new('/path/to/image.jpg').optimize
    end
  end
end
