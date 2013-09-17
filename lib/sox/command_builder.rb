module Sox
  # Builds +sox+ shell command from input files, output file, options and effects.
  #
  # @example
  #   builder = Sox::CommandBuilder.new(['in1.mp3', 'in2.ogg'], 'out.wav',
  #     {:combine => :mix},
  #     {:rate => 44100, :channels => 2}
  #   )
  #   builder.build  # => "sox --combine mix in1.mp3 in2.ogg out.wav rate 44100 channels 2"
  class CommandBuilder

    attr_accessor :input_files, :output_file, :options, :effects

    # @param input_files [Array<Sox::File>]
    # @param output_file [Sox::File]
    # @param options [Hash{Symbol => Symbol}]
    # @param effects [Hash{Symbol => Symbol}]
    def initialize(input_files, output_file, options = {}, effects = {})
      @input_files = input_files
      @output_file = output_file
      @options     = options
      @effects     = effects
    end

    # Build shell command with all arguments and options.
    #
    # @return [String]
    def build
      [ Sox::SOX_COMMAND,
        build_options(@options),
        build_input_files,
        build_file(@output_file),
        build_effects
      ].flatten.join(' ')
    end


    def build_input_files
      @input_files.map { |file| build_file(file) }
    end
    private :build_input_files


    def build_file(file)
      opts = build_options(file.options)
      file_path = file.escaped? ? file.path : Shellwords.escape(file.path)
      [opts, file_path]
    end
    private :build_file

    # Build options with their values (if present) to be used in shell command.
    #
    # @retrun [Array<String>] options
    def build_options(options)
      result = []
      options.each do |opt, val|
        result << "--#{shellify_opt(opt)}"
        result << shellify_opt(val) if [String, Symbol, Fixnum].include?(val.class)
      end
      result
    end
    private :build_options

    def build_effects
      result = []
      @effects.each do |effect, val|
        result << effect
        result << val if [String, Symbol, Fixnum].include?(val.class)
      end
      result
    end
    private :build_effects

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
