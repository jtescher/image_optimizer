class ImageOptimizer
  class JPEGOptimizer
    attr_reader :path, :options

    def initialize(path, options = {})
      @path = path
      @options = options
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
      system(jpeg_optimizer_bin, *command_options)
    end

    def command_options
      flags = ['-f', '--strip-all', '--all-progressive']
      flags << max_quantity if (0..100).include?(options[:quality])
      flags << quiet if options[:quiet]
      flags << path
    end

    def max_quantity
      "--max=#{options[:quality]}"
    end

    def quiet
      '--quiet'
    end

    def jpeg_optimizer_present?
      !jpeg_optimizer_bin.nil? && !jpeg_optimizer_bin.empty?
    end

    def jpeg_optimizer_bin
      @jpeg_optimizer_bin ||= ENV['JPEGOPTIM_BIN'] || `which jpegoptim`.strip
    end

  end
end
