class ImageOptimizer
  class ImageOptimizerBase
    include Shell

    attr_reader :path, :options

    def initialize(path, options = {})
      @path = path
      @options = options
    end

    def optimize
      return unless correct_format?(options[:identify])

      if bin_present?
        _optimize
      else
        warn "Attempting to optimize a #{type} without #{bin_name} installed. Skipping..."
      end
    end

    private
    def correct_format?(extension=nil)
      extensions.include? extension || extension(path)
    end

    def extension(path)
      path.split('.').last.downcase
    end

    def _optimize
      system(bin, *command_options)
    end


    def bin_present?
      !bin.nil? && !bin.empty?
    end

    def bin
      @bin ||= ENV["#{bin_name.upcase}_BIN"] || which(bin_name).strip
    end
  end
end