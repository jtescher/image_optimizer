class ImageOptimizer
  class JPEGOptimizer < ImageOptimizerBase

  private

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

    def extensions
      %w[jpeg jpg]
    end

    def type
      'jpeg'
    end

    def bin_name
      'jpegoptim'
    end

  end
end
