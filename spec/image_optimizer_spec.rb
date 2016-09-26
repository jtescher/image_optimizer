require 'spec_helper'

describe ImageOptimizer do
  let(:options) { {} }
  let(:image_path) { '/path/to/file.jpg' }

  describe '#optimize' do
    subject { ImageOptimizer.new(File.join(image_path), options) }

    it 'delegates to jpeg, png and gif optimizers' do
      expect_any_instance_of(ImageOptimizer::JPEGOptimizer).to receive(:optimize)
      expect_any_instance_of(ImageOptimizer::PNGOptimizer).to receive(:optimize)
      expect_any_instance_of(ImageOptimizer::GIFOptimizer).to receive(:optimize)
      subject.optimize
    end
  end

  describe '#identify_format' do

    context 'with identify option off' do
      subject { ImageOptimizer.new(File.join(image_path), options) }

      it 'does nothing' do
        expect(subject).to_not receive(:identify_format)
        subject.optimize
      end
    end

    context 'with identify option on' do
      let(:image_magick_data) do
        {
          :output => 'rose.jpg JPEG 640x480 sRGB 87kb 0.050u 0:01',
          :command => " -ping -quiet #{image_path}"
        }
      end
      let(:graphics_magick_data) do
        {
          :output => "Image: images/aquarium.jpg\nclass: PseudoClass\ncolors: 256\n" +
            "signature: eb5dca81dd93ae7e6ffae99a527eb5dca8...\nmatte: False\ngeometry: 640x480\ndepth: 8\nbytes: 308135" +
            "format: JPEG\ncomments:\nImported from MTV raster image: aquarium.mtv",
          :command => " -ping #{image_path}"
        }
      end

      subject { ImageOptimizer.new(File.join(image_path), options.merge(:identify => true)) }

      context 'with identify found thorough `which`' do
        let(:identify_bin_path) { '/usr/local/bin/identify' }
        before { allow(subject).to receive(:which).with('identify').and_return(identify_bin_path) }

        context 'for ImageMagick' do
          before { allow(subject).to receive(:which).with('mogrify').and_return('/usr/local/bin/mogrify') }

          it 'detects jpegs' do
            allow(subject).to receive(:run_command).and_return(image_magick_data[:output])
            subject.optimize
            expect(subject.options[:identified_format]).to eq('jpeg')
          end

          it 'calls the correct identify command' do
            expect(subject).to receive(:run_command).with(identify_bin_path + image_magick_data[:command]).and_return('')
            subject.optimize
          end
        end

        context 'for GraphicsMagick' do
          before { allow(subject).to receive(:which).with('mogrify').and_return(nil) }

          it 'detects jpegs' do
            allow(subject).to receive(:run_command).and_return(graphics_magick_data[:output])
            subject.optimize
            expect(subject.options[:identified_format]).to eq('jpeg')
          end

          it 'calls the correct identify command' do
            expect(subject).to receive(:run_command).with(identify_bin_path + graphics_magick_data[:command]).and_return('')
            subject.optimize
          end
        end
      end

      context 'with identify found in ENV' do
        let(:identify_bin_path) { '~/bin/identify' }
        before { ENV['IDENTIFY_BIN'] = identify_bin_path }
        after {  ENV['IDENTIFY_BIN'] = nil}

        context 'for ImageMagick' do
          before { allow(subject).to receive(:which).with('mogrify').and_return('/usr/local/bin/mogrify') }

          it 'detects jpegs' do
            allow(subject).to receive(:run_command).and_return(image_magick_data[:output])
            subject.optimize
            expect(subject.options[:identified_format]).to eq('jpeg')
          end

          it 'calls the correct identify command' do
            expect(subject).to receive(:run_command).with(identify_bin_path + image_magick_data[:command]).and_return('')
            subject.optimize
          end
        end

        context 'for GraphicsMagick' do
          before { allow(subject).to receive(:which).with('mogrify').and_return(nil) }

          it 'detects jpegs' do
            allow(subject).to receive(:run_command).and_return(graphics_magick_data[:output])
            subject.optimize
            expect(subject.options[:identified_format]).to eq('jpeg')
          end

          it 'calls the correct identify command' do
            expect(subject).to receive(:run_command).with(identify_bin_path + graphics_magick_data[:command]).and_return('')
            subject.optimize
          end
        end
      end

      context 'with identify not installed' do
        it 'warns the user' do
          allow(subject).to receive(:which).with('identify').and_return(nil)
          allow(subject).to receive(:identify_bin?).and_return(false)
          expect(subject).to receive(:warn).with('Attempting to retrieve image format without identify installed.' +
                                         ' Using file name extension instead...')
          subject.optimize
        end
      end

    end
  end
end
