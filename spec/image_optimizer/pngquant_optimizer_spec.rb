require 'spec_helper'

describe ImageOptimizer::PNGQuantOptimizer do
  describe '#optimize' do
    let(:options) { {} }
    let(:path) { '/path/to/file.png' }
    let(:pngquant_optimizer) { ImageOptimizer::PNGQuantOptimizer.new(path, options) }
    after { ImageOptimizer::PNGQuantOptimizer.instance_variable_set(:@bin, nil) }
    subject { pngquant_optimizer.optimize }

    context 'pngquant optimizing utility is installed' do
      before do
        allow(ImageOptimizer::PNGQuantOptimizer).to receive(:which).and_return('/usr/local/bin/pngquant')
      end

      it 'optimizes the png' do
        expected_cmd = %w[/usr/local/bin/pngquant --skip-if-larger --speed=1 --force --verbose --ext=.png --quality=100 /path/to/file.png]
        expect(pngquant_optimizer).to receive(:system).with(*expected_cmd)
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
          expected_cmd = %w[--skip-if-larger --speed=1 --force --verbose --ext=.png --quality=100 /path/to/file.png]
          expect(pngquant_optimizer).to receive(:system).with(image_pngquant_bin_path, *expected_cmd)
          subject
        end
      end

      context 'with quality parameter' do
        let(:options) { { :quality => 99 } }

        it 'optimizes the png with the quality' do
          expected_cmd = %w[/usr/local/bin/pngquant --skip-if-larger --speed=1 --force --verbose --ext=.png --quality=99 /path/to/file.png]
          expect(pngquant_optimizer).to receive(:system).with(*expected_cmd)
          subject
        end
      end

      context 'with quiet parameter' do
        let(:options) { { :quiet => true } }

        it 'optimizes the png with the quality' do
          expected_cmd = %w[/usr/local/bin/pngquant --skip-if-larger --speed=1 --force --ext=.png --quality=100 /path/to/file.png]
          expect(pngquant_optimizer).to receive(:system).with(*expected_cmd)
          subject
        end
      end

      context 'with space in file name' do
        let(:path) { '/path/to/file 2.png' }

        it do
          expected_cmd = %w[/usr/local/bin/pngquant --skip-if-larger --speed=1 --force --verbose --ext=.png --quality=100]
          expect(pngquant_optimizer).to receive(:system).with(*expected_cmd, path)
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
