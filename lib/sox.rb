require 'shellwords'
require 'open3'

require 'sox/command_builder'

# Wrapper around +sox+ command line tool.
#
# @example
#   # Concatenate files 3 mp3 files and write result in +output.ogg+.
#   sox = Sox.new("in1.mp3", "in2.mp3", "in3.mp3", :combine => :concatenate)
#   sox.write("output.ogg")
class Sox
  # Basic Sox error
  class Error < StandardError
  end

  # Sox command
  SHELL_COMMAND = 'sox'.freeze

  attr_reader :input_files, :options

  # @overload new(options)
  #   @param options [Hash] options for +sox+ tool
  #
  # @overload new(input_file, options)
  #
  # @overload new(input_file1, input_file2, options)
  def initialize(*files_and_opts)
    @options     = files_and_opts.last.is_a?(Hash) ? files_and_opts.pop : {}
    @input_files = files_and_opts
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
  #
  # @return [Boolean, nil] true if succeed, nil if failed.
  def write(output_file)
    command = CommandBuilder.new(@input_files, output_file, @options).build
    run_command(command)
  end



  # Run shell command which is supposed to be +sox+.
  # Raise {Sox::Error} if fail.
  #
  # @param command [String] shell command to be executed
  #
  # @return [Boolean] true in case of success otherwise {Sox::Error} is raised.
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
