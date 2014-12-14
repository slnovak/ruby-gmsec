class GMSEC::Connection
  extend GMSEC::API

  bind GMSEC_CONNECTION_OBJECT: :connection

  has :config, :status

  attach_function :gmsec_CreateConnectionForConfig, [GMSEC::Config, :pointer, GMSEC::Status], :void
  attach_function :gmsec_Connect, [self, GMSEC::Status], :void
  attach_function :gmsec_IsConnected, [self, GMSEC::Status], :int
  attach_function :gmsec_Disconnect, [self, GMSEC::Status], :void
  attach_function :gmsec_DestroyConnection, [self, GMSEC::Status], :void

  attr_accessor :config, :status

  def initialize(native_value: nil)

  end

  def connect
    gmsec_Connect(self, status)
  end

  def is_connected?
    gmsec_IsConnected(self, status) > 0
  end

  def disconnect
    gmsec_Connect(self, status)

  end

  def destroy!
    gmsec_DestroyConnection(self, status)
  end

  def publish(message, async: false, &block)

  end

  protected

  def connection
    @config ||= begin
      pointer = new_pointer
      gmsec_CreateConnectionForConfig(config, pointer, status)
      pointer.read_pointer
    end
  end

end
