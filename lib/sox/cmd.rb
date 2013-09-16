module Sox
  # Process audio files using +sox+ shell command.
  #
  # @example
  #   # Concatenate files 3 mp3 files and write result in +output.ogg+.
  #   sox = Sox::Cmd.new("in1.mp3", "in2.mp3", "in3.mp3", {:combine => :concatenate}, :rate => '8k')
  #   sox.write("output.ogg")
  class Cmd
    attr_accessor :input_files, :options, :effects

    # @overload new(options = {})
    #   @param options [Hash] options for +sox+ tool
    #
    # @overload new(in1, in2, options = {})
    #   @param in1 [String] path to input audio file
    #   @param in2 [String] path to input audio file
    #   @param options [Hash] options for +sox+ tool
    def initialize(*files_and_opts)
      @global_options = files_and_opts.last.is_a?(Hash) ? files_and_opts.pop : {}
      @input_files    = files_and_opts
    end

    # Add input file(s) to be processed.
    #
    # @param files [String, Array] file or array of files
    #
    # @retrun [void]
    def add_input_files(*files)
      @input_files.concat(files.flatten)
    end
    alias :<< :add_input_files

    # Run +sox+ command and write the result into output the file.
    #
    # @param filename [String] output file
    # @param effects [Hash] effects to apply on the output file
    #
    # @return [Boolean] true if succeed, otherwise {Sox::Error} is raised
    def write(output_file, effects = {})
      command = CommandBuilder.new(@input_files, output_file, @options, effects).build
      run_command(command)
    end

    # Run shell command which is supposed to be +sox+.
    # Raise {Sox::Error} if fail.
    #
    # @param command [String] shell command to be executed
    #
    # @return [Boolean] true in case of success, otherwise {Sox::Error} is raised
    def run_command(command)
      _, _, err_io, thread = Open3.popen3(command)
      thread.join

      process_status = thread.value
      if process_status.success?
        true
      else
        raise Error, err_io.read
      end
    rescue Errno::ENOENT => err
      msg = "#{err.message}. Do you have `#{SHELL_COMMAND}' installed?"
      raise Error, msg
    end
    private :run_command
  end
end
