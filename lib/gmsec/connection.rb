class GMSEC::Connection
  extend FFI::Library
  extend FFI::DataConverter
  extend GMSEC::API

  bind! :GMSEC_CONNECTION_OBJECT

  attach_function :gmsec_CreateConnectionForConfig, [GMSEC::Config, :pointer, GMSEC::Status], :void
  attach_function :gmsec_Connect, [self, GMSEC::Status], :void
  attach_function :gmsec_IsConnected, [self, GMSEC::Status], :int
  attach_function :gmsec_Disconnect, [self, GMSEC::Status], :void
  attach_function :gmsec_DestroyConnection, [self, GMSEC::Status], :void

  attr_accessor :config
  attr_accessor :status

  class ConnectionFactory
    extend FFI::Library
    extend FFI::DataConverter
    extend GMSEC::API
  end

  def connect

  end

  def is_connected?

  end

  def disconnect

  end

  def destroy!

  end

  protected

  def config
    @config ||= GMSEC::Config.new
  end

  def connection
  end

end
