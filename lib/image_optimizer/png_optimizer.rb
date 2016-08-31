class ImageOptimizer
  class PNGOptimizer < ImageOptimizerBase

  private

    def command_options
      flags = %W[-o#{level}]
      flags << quiet if options[:quiet]
      flags << path
    end

    def level
      options[:level] || 7
    end

    def quiet
      '-quiet'
    end

    def type
      'png'
    end

    def extensions
      %w[png gif]
    end

    def bin_name
      'optipng'
    end

  end
end
