module Sox
  class Combiner::ProcessSubstitutionStrategy < Combiner::BaseStrategy
    # Type of mediate files
    MEDIATE_TYPE = :sox

    # Number of bits for mediate files
    MEDIATE_BITS = 32

    # Encoding of mediate files
    MEDIATE_ENCODING = :signed

    # Pseudo file which makes `sox` command write to STDOUT
    SOX_PIPE = '-p'


    def write(output_file)
      inputs = @input_files.map { |file| build_input_file(file) }
      output = Sox::File.new(output_file)

      effects = {}
      effects[:norm] = true if @options[:normalize]

      cmd = CommandBuilder.new(inputs, output, {:combine => @options[:combine]}, effects).build

      bash(cmd)
    end

    def build_input_file(file_path)
      Sox::File.new(build_converted_input(file_path),
        :type     => MEDIATE_TYPE,
        :encoding => MEDIATE_ENCODING,
        :bits     => MEDIATE_BITS,
        :channels => @options[:channels],
        :rate     => @options[:rate]
     ).tap { |file| file.escaped = true }
    end


    def build_converted_input(input_file)
      input    = Sox::File.new(input_file)
      output   = Sox::File.new(SOX_PIPE, :encoding => MEDIATE_ENCODING, :bits => MEDIATE_BITS)
      effects  = {:channels => @options[:channels], :rate => @options[:rate]}
      command  = CommandBuilder.new([input], output, {}, effects).build
      process_substitution_wrap(command)
    end

    def process_substitution_wrap(command)
      "<(#{command})"
    end
  end
end
