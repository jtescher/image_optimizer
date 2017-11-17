require 'spec_helper'

describe ImageOptimizer::JPEGOptimizer do
  describe '#optimize' do
    let(:options) { {} }
    let(:jpeg_optimizer) { ImageOptimizer::JPEGOptimizer.new('/path/to/file.jpg', options) }
    after { ImageOptimizer::JPEGOptimizer.instance_variable_set(:@bin, nil) }
    subject { jpeg_optimizer.optimize }

    context 'jpeg optimizing utility is installed' do
      before do
        allow(ImageOptimizer::JPEGOptimizer).to receive(:which).and_return('/usr/local/bin/jpegoptim')
      end

      it 'optimizes the jpeg' do
        optimizer_options = %w[-f --strip-all --all-progressive /path/to/file.jpg]
        expect(jpeg_optimizer).to receive(:system).with('/usr/local/bin/jpegoptim', *optimizer_options)
        subject
      end

      context 'ENV variable path to jpegoptim' do
        let(:image_optim_jpegoptim_bin_path) { '/app/vendor/bundle/ruby/2.0.0/gems/image_optim_bin-0.0.2/bin/jpegoptim' }
        before do
          ENV['JPEGOPTIM_BIN'] = image_optim_jpegoptim_bin_path
        end
        after do
          ENV['JPEGOPTIM_BIN'] = nil
        end

        it 'should optimize using the given path' do
          optimizer_options = %w[-f --strip-all --all-progressive /path/to/file.jpg]
          expect(jpeg_optimizer).to receive(:system).with(image_optim_jpegoptim_bin_path, *optimizer_options)
          subject
        end
      end

      context 'with quality parameter' do
        let(:options) { { :quality => 50 } }

        it 'optimizes the jpeg with the quality' do
          optimizer_options = %w[-f --strip-all --all-progressive --max=50 /path/to/file.jpg]
          expect(jpeg_optimizer).to receive(:system).with('/usr/local/bin/jpegoptim', *optimizer_options)
          subject
        end
      end

      context 'with quiet parameter' do
        let(:options) { { :quiet => true } }

        it 'accepts an optional quiet parameter' do
          optimizer_options = %w[-f --strip-all --all-progressive --quiet /path/to/file.jpg]
          expect(jpeg_optimizer).to receive(:system).with('/usr/local/bin/jpegoptim', *optimizer_options)
          subject
        end
      end

      context 'with global quiet mode enabled' do
        before { ImageOptimizer.quiet = true }
        after { ImageOptimizer.quiet = false }

        it 'sets quiet parameter on the command line' do
          optimizer_options = %w[-f --strip-all --all-progressive --quiet /path/to/file.jpg]
          expect(jpeg_optimizer).to receive(:system).with('/usr/local/bin/jpegoptim', *optimizer_options)
          subject
        end
      end
    end

    context 'optimizing utility is not installed' do
      before do
        allow(ImageOptimizer::JPEGOptimizer).to receive(:which).and_return(nil)
      end

      it 'warns the user if the jpeg' do
        expect(jpeg_optimizer).to receive(:warn).with('Attempting to optimize a jpeg without jpegoptim installed. Skipping...')
        subject
      end
    end
  end
end
