module Sox
  # Alternative Combiner implementation with usage of named pipes
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
      convert_commands = @input_files.map { |file| convert_cmd(file) }

      cmd = build_output_cmd(convert_commands, output_file)

      bash_cmd = "/bin/bash -c '#{cmd}'"

      unless system bash_cmd
      end

    end

    def build_output_cmd(sub_commands, output_file)
      cmd = "#{SHELL_COMMAND} --combine #{@options[:combine]}"

      sub_commands.each do |subcmd|
        cmd << " #{subcmd}"
      end

      cmd << " " << Shellwords.escape(output_file)

      cmd << " norm" if @options[:normalize]

      cmd
    end


    def convert_cmd(input_file)
      input  = Shellwords.escape(input_file)
      subcmd =  " -t raw -r #{@options[:rate]} -c #{@options[:channels]} -e signed -b 32 "
      subcmd << "<(#{SHELL_COMMAND} #{input} -e signed -b 32 -p channels #{@options[:channels]} rate #{@options[:rate]})"
      subcmd
    end


    end
end
