require 'spec_helper'

describe ImageOptimizer do
  let(:options) { {} }
  let(:image_path) { '/path/to/file.jpg' }
  let(:image_optimizer) { ImageOptimizer.new(File.join(image_path), options) }
  after do
    ImageOptimizer.instance_variable_set(:@image_magick, nil)
    ImageOptimizer.instance_variable_set(:@identify, nil)
    ImageOptimizer::JPEGOptimizer.instance_variable_set(:@bin, nil)
    ImageOptimizer::PNGOptimizer.instance_variable_set(:@bin, nil)
  end

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
      expect(ImageOptimizer).to_not receive(:identify_present?)
    end

    context 'with identify option' do
      let(:options) { { :identify => true } }

      {
          true => 'with identify installed globally',
          false => 'with ENV path to identify'
      }.each do |install_identify, context_string|

        context context_string do
          if install_identify
            let(:identify_bin_path) { '/usr/local/bin/identify' }
            before do
              allow(ImageOptimizer).to receive(:which).with('identify').and_return(identify_bin_path)
            end
          else
            let(:identify_bin_path) { '~/bin/identify' }
            before do
              ENV['IDENTIFY_BIN'] = identify_bin_path
            end
            after do
              ENV['IDENTIFY_BIN'] = nil
            end
          end

          {
              'ImageMagick' => {
                  :image_magick? => '/usr/local/bin/mogrify',
                  :output => 'rose.jpg JPEG 640x480 sRGB 87kb 0.050u 0:01',
                  :command => " -ping -quiet /path/to/file.jpg"
              },
              'GraphicsMagick' => {
                  :image_magick? => nil,
                  :output => "Image: images/aquarium.jpg\nclass: PseudoClass\ncolors: 256\n" +
                      "signature: eb5dca81dd93ae7e6ffae99a527eb5dca8...\nmatte: False\ngeometry: 640x480\ndepth: 8\nbytes: 308135" +
                      "format: JPEG\ncomments:\nImported from MTV raster image: aquarium.mtv",
                  :command => " -ping /path/to/file.jpg"
              }
          }.each do |library, data|
            context "for #{library}" do
              before do
                allow(ImageOptimizer).to receive(:which).with('mogrify').and_return(data[:image_magick?])
                allow(image_optimizer).to receive(:run_command).and_return(data[:output])
              end

              it 'detects jpeg' do
                expect(subject).to eql 'jpeg'
              end

              it 'calls the right command' do
                expect(image_optimizer).to receive(:run_command).with(identify_bin_path + data[:command])
                subject
              end
            end
          end
        end
      end

      context 'with identify not installed' do
        before do
          allow(ImageOptimizer).to receive(:which).with('identify').and_return(nil)
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
