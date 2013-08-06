require 'spec_helper'

describe ImageOptimizer::JPEGOptimizer do
  describe '#optimize' do
    let(:file_path) { '/path/to/file.jpg' }
    let(:jpeg_optimizer) { ImageOptimizer::JPEGOptimizer.new(file_path) }

    it 'optimizes the jpeg' do
      jpeg_optimizer.stub(:jpeg_optimizer_bin => '/usr/local/bin/jpegoptim')
      jpeg_optimizer.should_receive(:system).with("/usr/local/bin/jpegoptim -f --strip-all #{file_path}")
      jpeg_optimizer.optimize
    end

    it 'warns the user if the jpeg optimizing utility is not installed' do
      jpeg_optimizer.stub(:jpeg_optimizer_bin => '')
      jpeg_optimizer.should_receive(:warn).with('Attempting to optimize a jpeg without jpegoptim installed. Skipping...')
      jpeg_optimizer.optimize
    end

    it 'detects if there is an ENV variable path to jpegoptim' do
      image_optim_jpegoptim_bin_path = '/app/vendor/bundle/ruby/2.0.0/gems/image_optim_bin-0.0.2/bin/jpegoptim'
      ENV['JPEGOPTIM_BIN'] = image_optim_jpegoptim_bin_path
      jpeg_optimizer.should_receive(:system).with("#{image_optim_jpegoptim_bin_path} -f --strip-all #{file_path}")
      jpeg_optimizer.optimize
    end
  end
end
