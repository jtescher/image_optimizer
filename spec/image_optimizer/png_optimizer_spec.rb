require 'spec_helper'

describe ImageOptimizer::PNGOptimizer do
  describe '#optimize' do
    let(:file_path) { '/path/to/file.png' }
    let(:png_optimizer) { ImageOptimizer::PNGOptimizer.new(file_path) }

    it 'optimizes the png' do
      png_optimizer.stub(:png_optimizer_present? => true)
      png_optimizer.should_receive(:system).with("optipng -o7 #{png_optimizer.path}")
      png_optimizer.optimize
    end

    it 'warns the user if the png optimizing utility is not installed' do
      png_optimizer.stub(:png_optimizer_present? => false)
      png_optimizer.should_receive(:warn).with('Attempting to optimize a png without optipng installed. Skipping...')
      png_optimizer.optimize
    end
  end
end