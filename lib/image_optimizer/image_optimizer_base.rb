class ImageOptimizer
  class ImageOptimizerBase
    include Shell

    attr_reader :path, :options
    def initialize(path, options = {})
      @path = path
      @options = options
    end

    def optimize
      return unless correct_format?

      if optimizer_bin?
        perform_optimizations
      else
        warn "Attempting to optimize a #{type} without #{bin_name} installed. Skipping..."
      end
    end

  private

    def correct_format?
      extensions.include?(options[:identified_format] || extension(path))
    end

    def extension(path)
      path.split('.').last.downcase
    end

    def perform_optimizations
      system(optimizer_bin, *command_options)
    end

    def optimizer_bin?
      !!optimizer_bin
    end

    def optimizer_bin
      ENV["#{bin_name.upcase}_BIN"] || which(bin_name)
    end

    def quiet?
      options[:quiet] || ImageOptimizer.quiet
    end

  end
end
