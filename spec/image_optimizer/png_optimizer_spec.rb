require 'spec_helper'

describe ImageOptimizer::PNGOptimizer do
  describe '#optimize' do
    let(:options) { {} }
    let(:png_optimizer) { ImageOptimizer::PNGOptimizer.new('/path/to/file.png', options) }
    after { ImageOptimizer::PNGOptimizer.instance_variable_set(:@bin, nil) }
    subject { png_optimizer.optimize }

    context 'with png optimizing utility installed' do
      before do
        allow(ImageOptimizer::PNGOptimizer).to receive(:which).and_return('/usr/local/bin/optipng')
      end

      it 'optimizes the png' do
        expect(png_optimizer).to receive(:system).with('/usr/local/bin/optipng', '-o7', '/path/to/file.png')
        subject
      end

      context 'ENV variable path to optipng' do
        let(:image_optim_optipng_bin_path) { '/app/vendor/bundle/ruby/2.0.0/gems/image_optim_bin-0.0.2/bin/optipng' }
        before do
          ENV['OPTIPNG_BIN'] = image_optim_optipng_bin_path
        end
        after do
          ENV['OPTIPNG_BIN'] = nil
        end

        it 'detects if there is an ENV variable path to optipng' do
          expect(png_optimizer).to receive(:system).with(image_optim_optipng_bin_path, '-o7', '/path/to/file.png')
          subject
        end
      end

      context 'with quiet parameter' do
        let(:options) { { :quiet => true } }
        it 'optimizes the png' do
          expect(png_optimizer).to receive(:system).with('/usr/local/bin/optipng', '-o7', '-quiet', '/path/to/file.png')
          subject
        end
      end
    end

    context 'with png optimizing utility not installed' do
      before do
        allow(ImageOptimizer::PNGOptimizer).to receive(:which).and_return(nil)
      end

      it 'warns the user' do
        expect(png_optimizer).to receive(:warn).with('Attempting to optimize a png without optipng installed. Skipping...')
        subject
      end
    end
  end
end
