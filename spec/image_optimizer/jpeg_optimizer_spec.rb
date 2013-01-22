require 'spec_helper'

describe ImageOptimizer::JPEGOptimizer do
  describe '#optimize' do
    let(:file_path) { '/path/to/file.jpg' }
    let(:jpeg_optimizer) { ImageOptimizer::JPEGOptimizer.new(file_path) }

    it 'optimizes the jpeg' do
      jpeg_optimizer.stub(:jpeg_optimizer_present? => true)
      jpeg_optimizer.should_receive(:system).with("jpegoptim -f --strip-all #{jpeg_optimizer.path}")
      jpeg_optimizer.optimize
    end

    it 'warns the user if the jpeg optimizing utility is not installed' do
      jpeg_optimizer.stub(:jpeg_optimizer_present? => false)
      jpeg_optimizer.should_receive(:warn).with('Attempting to optimize a jpeg without jpegoptim installed. Skipping...')
      jpeg_optimizer.optimize
    end
  end
end