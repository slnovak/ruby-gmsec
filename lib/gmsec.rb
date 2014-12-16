require 'ffi'

require 'gmsec/version'

module GMSEC
  autoload :Definitions, 'gmsec/definitions'
  autoload :API, 'gmsec/api'
  autoload :Status, 'gmsec/status'
  autoload :Config, 'gmsec/config'
  autoload :Connection, 'gmsec/connection'
  autoload :Field, 'gmsec/field'
  autoload :Message, 'gmsec/message'
end
