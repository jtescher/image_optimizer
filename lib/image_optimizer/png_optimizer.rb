class ImageOptimizer
  class PNGOptimizer < ImageOptimizerBase

  private

    def command_options
      flags = %w[-o7]
      flags << quiet if options[:quiet]
      flags << path
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
