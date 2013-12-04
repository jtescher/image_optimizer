class ImageOptimizer
  class PNGOptimizer
    attr_reader :path

    def initialize(path)
      @path = path
    end

    def optimize
      return unless png_format?

      if png_optimizer_present?
        optimize_png
      else
        warn 'Attempting to optimize a png without optipng installed. Skipping...'
      end
    end

  private

    def png_format?
      ['png', 'gif'].include? extension(path)
    end

    def extension(path)
      path.split('.').last.downcase
    end

    def optimize_png
      system "#{png_optimizer_bin} -o7 #{path}"
    end

    def png_optimizer_present?
      !png_optimizer_bin.nil? && !png_optimizer_bin.empty?
    end

    def png_optimizer_bin
      @png_optimzer_bin ||= ENV['OPTIPNG_BIN'] || `which optipng`.strip
    end

  end
end
