class Sox
  # Builds +sox+ shell command from input files, output file and options.
  #
  # @example
  #   builder = Sox::CommandBuilder.new(['in1.mp3', 'in2.ogg'], 'out.wav', :combine => :mix)
  #   builder.build  # => "sox --combine mix in1.mp3 in2.ogg out.wav"
  class CommandBuilder
    # @param input_files [Array<String>]
    # @param output_file [String]
    # @param options [Hash{Symbol => Symbol}]
    def initialize(input_files, output_file, options = {})
      @input_files = input_files
      @output_file = output_file
      @options     = options
    end


    # Build shell command with all arguments and options.
    #
    # @return [String]
    def build
      [ Sox::SHELL_COMMAND,
        build_options,
        @input_files.map {|file| Shellwords.escape(file) },
        Shellwords.escape(@output_file)
      ].flatten.join(' ')
    end

    # Build options with their values (if present) to be used in shell command.
    #
    # @retrun [Array<String>] options
    def build_options
      result = []
      @options.each do |opt, val|
        result << "--#{shellify_opt(opt)}"
        result << shellify_opt(val) if [String, Symbol].include?(val.class)
      end
      result
    end
    private :build_options

    # Convert option or its value to shell style, separating words with "-".
    #
    # @param value [Symbol, String] option or value
    #
    # @retrun [String] shellified option
    def shellify_opt(value)
      value.to_s.gsub('_', '-')
    end
    private :shellify_opt
  end
end
