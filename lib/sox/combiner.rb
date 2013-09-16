module Sox
  class Combiner

    # Default options
    DEFAULT_OPTIONS = {
      # Method to be used for combining sounds. See --combine of sox tool.
      :combine => :concatenate,

      # Number of channels in the output file.
      :channels => 1,

      # Rate(samples per seconds) of the output file.
      :rate => 22050,

      # Apply norm effect on output
      :normalize => true
    }


    def self.combine(input_files, output_file, options = {})
      new(input_files, options).write(output_file)
    end

    def initialize(input_files, options = {})
      @input_files = input_files
      @options     = DEFAULT_OPTIONS.merge(options)
    end

    def write(output_file)
      tmp_files = []

      @input_files.each do |input_file|
        tmp_output_file = gen_tmp_filename
        tmp_files << tmp_output_file

        cmd = build_convert_cmd(input_file, tmp_output_file)
        unless system cmd
          abort cmd
        end
      end

      cmd = build_output_cmd(tmp_files, output_file)

      # TODO: raise  exception on failure
      system cmd
    ensure
      tmp_files.each do |file|
        FileUtils.rm file
      end
    end

    def gen_tmp_filename
      Dir::Tmpname.make_tmpname ['/tmp/ruby-sox', '.raw'], nil
    end

    def build_convert_cmd(input_file, output_file)
      input  = Shellwords.escape(input_file)
      output = Shellwords.escape(output_file)

      "#{SHELL_COMMAND} #{input} #{output} channels #{@options[:channels]} rate #{@options[:rate]}"
    end

    def build_output_cmd(input_files, output_file)
      cmd = "#{SHELL_COMMAND} --combine #{@options[:combine]}"

      input_files.each do |input|
        cmd << " -t raw -r #{@options[:rate]} -c #{@options[:channels]} -e signed -b 16 "
        cmd << input
      end

      cmd << " " << Shellwords.escape(output_file)
      cmd << " norm" if @options[:normalize]

      cmd
    end

  end
end
