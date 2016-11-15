require 'spec_helper'

describe ImageOptimizer::PNGQuantOptimizer do
  describe '#optimize' do
    let(:options) { {} }
    let(:pngquant_optimizer) { ImageOptimizer::PNGQuantOptimizer.new('/path/to/file.png', options) }
    after { ImageOptimizer::PNGQuantOptimizer.instance_variable_set(:@bin, nil) }
    subject { pngquant_optimizer.optimize }

    context 'pngquant optimizing utility is installed' do
      before do
        allow(ImageOptimizer::PNGQuantOptimizer).to receive(:which).and_return('/usr/local/bin/pngquant')
      end

      it 'optimizes the png' do
        optimizer_options = %w[--skip-if-larger --speed\ 1 --force --verbose --ext\ .png --quality\ 100 /path/to/file.png]
        expect(pngquant_optimizer).to receive(:system).with('/usr/local/bin/pngquant', *optimizer_options)
        subject
      end

      context 'ENV variable path to pngquant' do
        let(:image_pngquant_bin_path) { '/app/vendor/bundle/ruby/2.0.0/gems/image_pngquant_bin-0.0.2/bin/pngquant' }
        before do
          ENV['PNGQUANT_BIN'] = image_pngquant_bin_path
        end
        after do
          ENV['PNGQUANT_BIN'] = nil
        end

        it 'should optimize using the given path' do
          optimizer_options = %w[--skip-if-larger --speed\ 1 --force --verbose --ext\ .png --quality\ 100 /path/to/file.png]
          expect(pngquant_optimizer).to receive(:system).with(image_pngquant_bin_path, *optimizer_options)
          subject
        end
      end

      context 'with quality parameter' do
        let(:options) { { :quality => 100 } }

        it 'optimizes the png with the quality' do
          optimizer_options = %w[--skip-if-larger --speed\ 1 --force --verbose --ext\ .png --quality\ 100 /path/to/file.png]
          expect(pngquant_optimizer).to receive(:system).with('/usr/local/bin/pngquant', *optimizer_options)
          subject
        end
      end
    end

    context 'optimizing utility is not installed' do
      before do
        allow(ImageOptimizer::PNGQuantOptimizer).to receive(:which).and_return(nil)
      end

      it 'warns the user if the png' do
        expect(pngquant_optimizer).to receive(:warn).with('Attempting to optimize a png without pngquant installed. Skipping...')
        subject
      end
    end
  end
end
