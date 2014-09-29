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

      if self.class.bin?
        _optimize
      else
        warn "Attempting to optimize a #{self.class.type} without #{self.class.bin_name} installed. Skipping..."
      end
    end

    private
    def correct_format?(extension=nil)
      self.class.extensions.include? extension || extension(path)
    end

    def extension(path)
      path.split('.').last.downcase
    end

    def _optimize
      system(self.class.bin, *command_options)
    end


    class << self
      def bin?
        !!bin
      end
      def bin
        @bin ||= ENV["#{bin_name.upcase}_BIN"] || which(bin_name)
      end
    end
  end
end