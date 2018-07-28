class ImageOptimizer
  class PNGQuantOptimizer < ImageOptimizerBase

  private

    def command_options
      flags = ['--skip-if-larger', '--speed=1',
               '--force', '--verbose', '--ext=.png']

      flags -= ['--verbose'] if quiet?
      flags << quality
      flags << path
    end

    def quality
      return "--quality=100" unless (0..100).include?(options[:quality])
      "--quality=#{options[:quality]}"
    end

    def extensions
      %w[png]
    end

    def type
      'png'
    end

    def bin_name
      'pngquant'
    end

  end
end
