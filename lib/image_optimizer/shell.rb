class ImageOptimizer
  module Shell
    # most of the code from MiniMagick, they didn't write any tests

    # Cross-platform way of finding an executable in the $PATH.
    def which(cmd)
      exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
      ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
        exts.each do |ext|
          exe = File.join(path, "#{cmd}#{ext}")
          return exe if File.executable? exe
        end
      end
      nil
    end

    def run_command(command)
      `#{command}`
    end
  end
end