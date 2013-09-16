require 'shellwords'
require 'open3'
require 'tempfile'


# Wrapper around +sox+ command line tool.
#
module Sox
  # Basic Sox error
  class Error < StandardError
  end

  # Sox command
  SHELL_COMMAND = 'sox'.freeze
end


require 'sox/command_builder'
require 'sox/cmd'
require 'sox/combiner'
