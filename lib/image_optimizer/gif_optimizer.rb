class ImageOptimizer
  class GIFOptimizer < ImageOptimizerBase

  private

    def command_options
      flags = %W[-b -O#{level}]
      flags << path
    end

    def level
      options[:gif_level] || 1
    end

    def type
      'gif'
    end

    def extensions
      %w[gif]
    end

    def bin_name
      'gifsicle'
    end

  end
end
