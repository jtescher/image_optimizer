require 'spec_helper'

describe ImageOptimizer::JPEGOptimizer do
  describe '#optimize' do
    let(:jpeg_optimizer) { ImageOptimizer::JPEGOptimizer.new('/path/to/file.jpg') }

    it 'optimizes the jpeg' do
      jpeg_optimizer.stub(:bin => '/usr/local/bin/jpegoptim')
      optimizer_options = %w[-f --strip-all --all-progressive /path/to/file.jpg]
      jpeg_optimizer.should_receive(:system).with('/usr/local/bin/jpegoptim', *optimizer_options)
      jpeg_optimizer.optimize
    end

    it 'warns the user if the jpeg optimizing utility is not installed' do
      jpeg_optimizer.stub(:bin => '')
      jpeg_optimizer.should_receive(:warn).with('Attempting to optimize a jpeg without jpegoptim installed. Skipping...')
      jpeg_optimizer.optimize
    end

    it 'detects if there is an ENV variable path to jpegoptim' do
      image_optim_jpegoptim_bin_path = '/app/vendor/bundle/ruby/2.0.0/gems/image_optim_bin-0.0.2/bin/jpegoptim'
      ENV['JPEGOPTIM_BIN'] = image_optim_jpegoptim_bin_path
      optimizer_options = %w[-f --strip-all --all-progressive /path/to/file.jpg]
      jpeg_optimizer.should_receive(:system).with(image_optim_jpegoptim_bin_path, *optimizer_options)
      jpeg_optimizer.optimize
    end

    it 'accepts an optional quality parameter' do
      jpeg_optimizer = ImageOptimizer::JPEGOptimizer.new('/path/to/file.jpg', :quality => 50)
      jpeg_optimizer.stub(:bin => '/usr/local/bin/jpegoptim')
      optimizer_options = %w[-f --strip-all --all-progressive --max=50 /path/to/file.jpg]
      jpeg_optimizer.should_receive(:system).with('/usr/local/bin/jpegoptim', *optimizer_options)
      jpeg_optimizer.optimize
    end

    it 'accepts an optional quiet parameter' do
      jpeg_optimizer = ImageOptimizer::JPEGOptimizer.new('/path/to/file.jpg', :quiet => true)
      jpeg_optimizer.stub(:bin => '/usr/local/bin/jpegoptim')
      optimizer_options = %w[-f --strip-all --all-progressive --quiet /path/to/file.jpg]
      jpeg_optimizer.should_receive(:system).with('/usr/local/bin/jpegoptim', *optimizer_options)
      jpeg_optimizer.optimize
    end
  end
end
