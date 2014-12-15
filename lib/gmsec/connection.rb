class GMSEC::Connection
  extend GMSEC::API

  bind GMSEC_CONNECTION_OBJECT: :connection

  has :config, :status


  def initialize(native_value: nil)
    if native_value
      @connection = native_value
    end
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


  attach_function :gmsec_CloneMessage, [self, GMSEC::Message, :pointer, GMSEC::Status], :void
  attach_function :gmsec_Connect, [self, GMSEC::Status], :void
  attach_function :gmsec_CreateMessage, [self, :string, :GMSEC_MSG_KIND, :pointer, GMSEC::Status], :void
  attach_function :gmsec_CreateMessageDflt, [self, :pointer, GMSEC::Status], :void
  attach_function :gmsec_CreateMessageWCFG, [self, :string, :GMSEC_MSG_KIND, :pointer, GMSEC::Config, GMSEC::Status], :void
  attach_function :gmsec_DestroyMessage, [self, GMSEC::Message, GMSEC::Status], :void
  attach_function :gmsec_Disconnect, [self, GMSEC::Status], :void
  attach_function :gmsec_DispatchMsg, [self, :pointer, GMSEC::Status], :void
  attach_function :gmsec_GetLastDispatcherStatus, [self, GMSEC::Status], :void
  attach_function :gmsec_GetLibraryRootName, [self, :pointer, GMSEC::Status], :void
  attach_function :gmsec_GetLibraryVersion, [self, :pointer, GMSEC::Status], :void
  attach_function :gmsec_GetNextMsg, [self, :pointer, :GMSEC_I32, GMSEC::Status], :void
  attach_function :gmsec_IsConnected, [self, GMSEC::Status], :void
  attach_function :gmsec_Publish, [self, GMSEC::Message, GMSEC::Status], :void
  attach_function :gmsec_RegisterErrorCallback, [self, :string, :pointer, GMSEC::Status], :void
  attach_function :gmsec_Reply, [self, GMSEC::Message,GMSEC::Message, GMSEC::Status], :void
  attach_function :gmsec_Request, [self, GMSEC::Message, :GMSEC_I32, :pointer, GMSEC::Status], :void
  attach_function :gmsec_RequestWCallback, [self, GMSEC::Message, :GMSEC_I32, :pointer, GMSEC::Status], :void
  attach_function :gmsec_RequestWReplyCallback, [self, GMSEC::Message, :GMSEC_I32, :pointer, :pointer, GMSEC::Status], :void
  attach_function :gmsec_StartAutoDispatch, [self, GMSEC::Status], :void
  attach_function :gmsec_StopAutoDispatch, [self, GMSEC::Status], :void
  attach_function :gmsec_Subscribe, [self, :string, GMSEC::Status], :void
  attach_function :gmsec_SubscribeWCallback, [self, :string, :pointer, GMSEC::Status], :void
  attach_function :gmsec_UnSubscribe, [self, :string, GMSEC::Status], :void
  attach_function :gmsec_UnSubscribeWCallback, [self, :string, :pointer, GMSEC::Status], :void

end
