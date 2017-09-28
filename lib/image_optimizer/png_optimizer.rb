class ImageOptimizer
  class PNGOptimizer < ImageOptimizerBase

  private

    def command_options
      flags = %W[-o#{level}]
      flags << strip_metadata if strip_metadata?
      flags << quiet if quiet?
      flags << path
    end

    def level
      options[:level] || 7
    end

    def strip_metadata
      '-strip all'
    end

    def strip_metadata?
      return options[:strip_metadata] if options.key? :strip_metadata
      true
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
