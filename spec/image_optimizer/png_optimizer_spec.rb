require 'spec_helper'

describe ImageOptimizer::PNGOptimizer do
  describe '#optimize' do
    let(:png_optimizer) { ImageOptimizer::PNGOptimizer.new('/path/to/file.png') }

    it 'optimizes the png' do
      png_optimizer.stub(:png_optimizer_bin => '/usr/local/bin/optipng')
      png_optimizer.should_receive(:system).with('/usr/local/bin/optipng', '-o7', '/path/to/file.png')
      png_optimizer.optimize
    end

    it 'warns the user if the png optimizing utility is not installed' do
      png_optimizer.stub(:png_optimizer_bin => '')
      png_optimizer.should_receive(:warn).with('Attempting to optimize a png without optipng installed. Skipping...')
      png_optimizer.optimize
    end

    it 'detects if there is an ENV variable path to optipng' do
      image_optim_optipng_bin_path = '/app/vendor/bundle/ruby/2.0.0/gems/image_optim_bin-0.0.2/bin/optipng'
      ENV['OPTIPNG_BIN'] = image_optim_optipng_bin_path
      png_optimizer.should_receive(:system).with(image_optim_optipng_bin_path, '-o7', '/path/to/file.png')
      png_optimizer.optimize
    end

    it 'accepts an optional quiet parameter' do
      png_optimizer = ImageOptimizer::PNGOptimizer.new('/path/to/file.png', :quiet => true)
      png_optimizer.stub(:png_optimizer_bin => '/usr/local/bin/optipng')
      png_optimizer.should_receive(:system).with('/usr/local/bin/optipng', '-o7', '-quiet', '/path/to/file.png')
      png_optimizer.optimize
    end
  end
end
