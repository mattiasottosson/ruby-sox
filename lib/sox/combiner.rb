module Sox
  class Combiner

    autoload :BaseStrategy                , 'sox/combiner/base_strategy'
    autoload :TmpFileStrategy             , 'sox/combiner/tmp_file_strategy'
    autoload :ProcessSubstitutionStrategy , 'sox/combiner/process_substitution_strategy'

    # Default options
    DEFAULT_OPTIONS = {
      # Method to be used for combining sounds. See --combine of sox tool.
      :combine => :concatenate,

      # Number of channels in the output file.
      :channels => 1,

      # Rate(samples per seconds) of the output file.
      :rate => 22050,

      # Apply norm effect on output
      :normalize => false,

      # Strategy to convert input files into files with same rate and channels
      :strategy => :process_substitution
    }

    STRATEGIES = {
      :tmp_file             => TmpFileStrategy,
      :process_substitution => ProcessSubstitutionStrategy
    }


    def self.combine(input_files, output_file, options = {})
      new(input_files, options).write(output_file)
    end

    def initialize(input_files, options = {})
      raise(ArgumentError, "Input files are missing") if input_files.empty?

      opts           = DEFAULT_OPTIONS.merge(options)
      strategy_class = STRATEGIES[opts.delete(:strategy)]
      @strategy      = strategy_class.new(input_files, opts)
    end

    def write(output_file)
      @strategy.write(output_file)
    end

  end
end
