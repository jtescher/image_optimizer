require 'spec_helper'

describe ImageOptimizer do
  let(:options) { {} }
  let(:image_optimizer) { ImageOptimizer.new(File.join('/path/to/file.jpg'), options) }

  describe '#optimize' do
    subject { image_optimizer.optimize }

    it 'delegates to jpeg and png optimizers' do
      expect_any_instance_of(ImageOptimizer::JPEGOptimizer).to receive(:optimize)
      expect_any_instance_of(ImageOptimizer::PNGOptimizer).to receive(:optimize)
      subject
    end
  end

  describe '#format' do
    subject { image_optimizer.format }

    it 'does nothing' do
      expect(image_optimizer).to_not receive(:identify_present?)
    end

    context 'with identify option' do
      let(:options) { { :identify => true } }

      context 'with #identify_present?' do
        before do
          allow(image_optimizer).to receive(:which).with('identify').and_return(true)
        end

        {
            'ImageMagick' => {
                :image_magick? => true,
                :output => 'rose.jpg JPEG 640x480 sRGB 87kb 0.050u 0:01',
                :command => "identify -ping -quiet /path/to/file.jpg"
            },
            'GraphicsMagick' => {
                :image_magick? => false,
                :output => "Image: images/aquarium.jpg\nclass: PseudoClass\ncolors: 256\n" +
                    "signature: eb5dca81dd93ae7e6ffae99a527eb5dca8...\nmatte: False\ngeometry: 640x480\ndepth: 8\nbytes: 308135" +
                    "format: JPEG\ncomments:\nImported from MTV raster image: aquarium.mtv",
                :command => "identify -ping /path/to/file.jpg"
            }
        }.each do |library, data|
          context "for #{library}" do
            before do
              allow(image_optimizer).to receive(:which).with('mogrify').and_return(data[:image_magick?])
              allow(image_optimizer).to receive(:run_command).and_return(data[:output])
            end

            it 'detects jpeg' do
              expect(subject).to eql 'jpeg'
            end

            it 'calls the right command' do
              expect(image_optimizer).to receive(:run_command).with(data[:command])
              subject
            end
          end
        end
      end

      context 'with not #identify_present?' do
        before do
          allow(image_optimizer).to receive(:which).with('identify').and_return(false)
        end

        it 'warns the user' do
          expect(image_optimizer).
              to receive(:warn).with('Attempting to retrieve image format without identify installed.' +
                                         ' Using file name extension instead...')
          subject
        end
      end
    end
  end
end
