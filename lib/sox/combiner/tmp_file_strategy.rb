module Sox
  class Combiner::TmpFileStrategy < Combiner::BaseStrategy
    # Type of temporary mediate files
    MEDIATE_TYPE = :raw

    # Number of bits for temporary mediate files
    MEDIATE_BITS = 16

    # Encoding of temporary mediate files
    MEDIATE_ENCODING = :signed

    def write(output_file)
      tmp_files = []

      @input_files.each do |input_file|
        tmp_output_file = gen_tmp_filename
        tmp_files << tmp_output_file

        cmd = build_convert_cmd(input_file, tmp_output_file)
        sh(cmd)
      end

      cmd = build_output_cmd(tmp_files, output_file)

      sh(cmd)
    ensure
      # Remove temporary files
      tmp_files.each { |file| FileUtils.rm(file) if ::File.exists?(file) }
    end

    def gen_tmp_filename
      Dir::Tmpname.make_tmpname ['/tmp/ruby-sox', ".#{MEDIATE_TYPE}"], nil
    end

    def build_convert_cmd(input_file, output_file)
      builder = CommandBuilder.new([Sox::File.new(input_file)], Sox::File.new(output_file))
      builder.effects = {:channels => @options[:channels], :rate => @options[:rate]}
      builder.build
    end

    def build_output_cmd(input_files, output_file)
      inputs = input_files.map do |path|
        Sox::File.new(path,
          :type     => MEDIATE_TYPE,
          :encoding => MEDIATE_ENCODING,
          :bits     => MEDIATE_BITS,
          :channels => @options[:channels],
          :rate     => @options[:rate])
      end

      output = Sox::File.new(output_file)
      effects = []
      effects << 'norm' if @options[:normalize]

      builder = CommandBuilder.new(inputs, output, {:combine => @options[:combine]}, effects)
      builder.build
    end
  end
end
