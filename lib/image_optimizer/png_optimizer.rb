class ImageOptimizer
  class PNGOptimizer < ImageOptimizerBase
  private
    def type
      'png'
    end

    def bin_name
      'optipng'
    end

    def extensions
      %w[png gif]
    end

    def command_options
      flags = %w[-o7]
      flags << quiet if options[:quiet]
      flags << path
    end

    def quiet
      '-quiet'
    end
  end
end
