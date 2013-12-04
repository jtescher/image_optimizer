class ImageOptimizer
  class JPEGOptimizer
    attr_reader :path, :quality

    def initialize(path, options = {})
      @path = path
      @quality = options[:quality]
    end

    def optimize
      return unless jpeg_format?

      if jpeg_optimizer_present?
        optimize_jpeg
      else
        warn 'Attempting to optimize a jpeg without jpegoptim installed. Skipping...'
      end
    end

  private

    def jpeg_format?
      ['jpeg', 'jpg'].include? extension(path)
    end

    def extension(path)
      path.split('.').last.downcase
    end

    def optimize_jpeg
      system "#{jpeg_optimizer_bin} -f --strip-all #{optional_max_quality} --all-progressive #{path}"
    end

    def optional_max_quality
      "--max=#{quality}" if (0..100).include?(quality)
    end

    def jpeg_optimizer_present?
      !jpeg_optimizer_bin.nil? && !jpeg_optimizer_bin.empty?
    end

    def jpeg_optimizer_bin
      @jpeg_optimizer_bin ||= ENV['JPEGOPTIM_BIN'] || `which jpegoptim`.strip
    end

  end
end
