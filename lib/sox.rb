require 'shellwords'
require 'open3'
require 'tempfile'

# Wrapper around +sox+ command line tool.
module Sox
  # Basic Sox error
  class Error < StandardError
  end

  # Sox command
  SOX_COMMAND = 'sox'.freeze
end

require 'sox/file'
require 'sox/shell'
require 'sox/command_builder'
require 'sox/cmd'
require 'sox/combiner'
