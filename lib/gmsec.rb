require 'ffi'
require 'terminal-table'

require 'gmsec/version'

module GMSEC
  autoload :API, 'gmsec/api'
  autoload :Config, 'gmsec/config'
  autoload :ConfigFile, 'gmsec/config_file'
  autoload :Connection, 'gmsec/connection'
  autoload :Definitions, 'gmsec/definitions'
  autoload :Field, 'gmsec/field'
  autoload :Message, 'gmsec/message'
  autoload :Status, 'gmsec/status'
end
