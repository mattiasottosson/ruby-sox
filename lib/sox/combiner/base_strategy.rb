module Sox
  class Combiner::BaseStrategy
    include Sox::Shell

    def initialize(input_files, options)
      @input_files = input_files
      @options     = options
    end

    def write(output_file)
      raise NotImplementedError, __method__
    end
  end
end
