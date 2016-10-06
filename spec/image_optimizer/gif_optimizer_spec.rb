require 'spec_helper'

describe ImageOptimizer::GIFOptimizer do
  describe '#optimize' do
    let(:options) { {} }
    let(:gif_optimizer) { ImageOptimizer::GIFOptimizer.new('/path/to/file.gif', options) }
    after { ImageOptimizer::GIFOptimizer.instance_variable_set(:@bin, nil) }
    subject { gif_optimizer.optimize }

    context 'with gif optimizing utility installed' do
      before do
        allow(ImageOptimizer::GIFOptimizer).to receive(:which).and_return('/usr/local/bin/gifsicle')
      end

      it 'optimizes the gif' do
        expect(gif_optimizer).to receive(:system).with('/usr/local/bin/gifsicle', '-b', '-O1', '/path/to/file.gif')
        subject
      end

      context 'ENV variable path to gifsicle' do
        let(:image_optim_gifsicle_bin_path) { '/app/vendor/bundle/ruby/2.0.0/gems/image_optim_bin-0.0.2/bin/gifsicle' }
        before do
          ENV['GIFSICLE_BIN'] = image_optim_gifsicle_bin_path
        end
        after do
          ENV['GIFSICLE_BIN'] = nil
        end

        it 'detects if there is an ENV variable path to gifsicle' do
          expect(gif_optimizer).to receive(:system).with(image_optim_gifsicle_bin_path, '-b', '-O1', '/path/to/file.gif')
          subject
        end
      end

      context 'without optimization parameter' do
        it 'optimizes the gif with level 1 optimization' do
          expect(gif_optimizer).to receive(:system).with('/usr/local/bin/gifsicle', '-b', '-O1', '/path/to/file.gif')
          subject
        end
      end

      context 'with optimization parameter' do
        let(:options) { { gif_level: 2 } }
        it 'optimizes the gif with the requested optimization level' do
          expect(gif_optimizer).to receive(:system).with('/usr/local/bin/gifsicle', '-b', '-O2', '/path/to/file.gif')
          subject
        end
      end
    end


    context 'with gif optimizing utility not installed' do
      before do
        allow(ImageOptimizer::GIFOptimizer).to receive(:which).and_return(nil)
      end

      it 'warns the user' do
        expect(gif_optimizer).to receive(:warn).with('Attempting to optimize a gif without gifsicle installed. Skipping...')
        subject
      end
    end
  end
end
