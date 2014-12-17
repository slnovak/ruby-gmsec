class GMSEC::Connection
  extend GMSEC::API

  bind :GMSEC_CONNECTION_OBJECT

  has :config, :status

  GMSEC_MESSAGE_TYPE = {
    publish:  GMSEC_MSG_PUBLISH,
    reply:    GMSEC_MSG_REPLY,
    request:  GMSEC_MSG_REQUEST,
    unset:    GMSEC_MSG_UNSET }

  def connect
    # We initialize the connection assuming that a config is provided before connecting.
    initialize_native_object do |pointer|
      gmsec_CreateConnectionForConfig(config, pointer, status)
    end

    gmsec_Connect(self, status)
  end

  def connected?
    gmsec_IsConnected(self, status) == self.class.enum_type(:GMSEC_BOOL)[:GMSEC_TRUE]
  end

  def disconnect
    gmsec_Disconnect(self, status)
  end

  def publish(subject, payload, type: :publish, config: nil, is_default: false, &block)
    unless message_type = GMSEC_MESSAGE_TYPE[type]
      raise RuntimeError "Message type '#{type}' is not supported."
    end

    pointer = FFI::MemoryPointer.new(GMSEC::Message.native_type)

    gmsec_CreateMessage(self, subject, message_type, pointer, status)

    message = GMSEC::Message.new(native_object: pointer.read_pointer)
    
    message << payload

    gmsec_Publish(self, message, status)
  end

  def subscribe(subject, &block)
    if block_given?

      callback = FFI::Function.new(:void, [find_type(:GMSEC_CONNECTION_OBJECT), find_type(:GMSEC_MESSAGE_OBJECT)]) do |native_connection, native_message|
        connection = GMSEC::Connection.new(native_object: native_connection)
        message = GMSEC::Message.new(native_object: native_message)

        block.call(connection, message)
      end

      gmsec_SubscribeWCallback(self, subject, callback, status)
    else
      gmsec_Subscribe(self, subject, status)
    end
  end

  def messages(timeout: 1000, dispatch: true)
    Enumerator.new do |y|
      pointer = FFI::MemoryPointer.new(GMSEC::Message.native_type)
      gmsec_GetNextMsg(self, pointer, timeout, status)

      while status.code != GMSEC_TIMEOUT_OCCURRED && status.code == 0
        message = GMSEC::Message.new(native_object: pointer.read_pointer)

        if dispatch
          gmsec_DispatchMsg(self, message, status)
        end

        y << message

        gmsec_GetNextMsg(self, pointer, timeout, status)
      end
    end
  end

  def library_version
    with_string_buffer do |pointer|
      gmsec_GetLibraryVersion(self, pointer, status)
    end
  end

  def start_auto_dispatch
    gmsec_StartAutoDispatch(self, status)
  end

  def stop_auto_dispatch
    gmsec_StopAutoDispatch(self, status)
  end

  def dispatcher_status
    GMSEC::Status.new.tap do |status|
      gmsec_GetLastDispatcherStatus(self, status)
    end
  end

  protected

  attach_function :gmsec_CloneMessage, [self, GMSEC::Message, :pointer, GMSEC::Status], :void
  attach_function :gmsec_Connect, [self, GMSEC::Status], :void
  attach_function :gmsec_CreateMessage, [self, :string, :GMSEC_MSG_KIND, :pointer, GMSEC::Status], :void
  attach_function :gmsec_CreateMessageDflt, [self, :pointer, GMSEC::Status], :void
  attach_function :gmsec_CreateMessageWCFG, [self, :string, :GMSEC_MSG_KIND, :pointer, GMSEC::Config, GMSEC::Status], :void
  attach_function :gmsec_DestroyMessage, [self, GMSEC::Message, GMSEC::Status], :void
  attach_function :gmsec_Disconnect, [self, GMSEC::Status], :void
  attach_function :gmsec_DispatchMsg, [self, GMSEC::Message, GMSEC::Status], :void
  attach_function :gmsec_GetLastDispatcherStatus, [self, GMSEC::Status], :void
  attach_function :gmsec_GetLibraryRootName, [self, :pointer, GMSEC::Status], :void
  attach_function :gmsec_GetLibraryVersion, [self, :pointer, GMSEC::Status], :void
  attach_function :gmsec_GetNextMsg, [self, :pointer, :GMSEC_I32, GMSEC::Status], :void
  attach_function :gmsec_IsConnected, [self, GMSEC::Status], :int
  attach_function :gmsec_Publish, [self, GMSEC::Message, GMSEC::Status], :void
  attach_function :gmsec_RegisterErrorCallback, [self, :string, :pointer, GMSEC::Status], :void
  attach_function :gmsec_Reply, [self, GMSEC::Message, GMSEC::Message, GMSEC::Status], :void
  attach_function :gmsec_Request, [self, GMSEC::Message, :GMSEC_I32, :pointer, GMSEC::Status], :void
  attach_function :gmsec_RequestWCallback, [self, GMSEC::Message, :GMSEC_I32, :pointer, GMSEC::Status], :void
  attach_function :gmsec_RequestWReplyCallback, [self, GMSEC::Message, :GMSEC_I32, :pointer, :pointer, GMSEC::Status], :void
  attach_function :gmsec_StartAutoDispatch, [self, GMSEC::Status], :void
  attach_function :gmsec_StopAutoDispatch, [self, GMSEC::Status], :void
  attach_function :gmsec_Subscribe, [self, :string, GMSEC::Status], :void
  attach_function :gmsec_SubscribeWCallback, [self, :string, :pointer, GMSEC::Status], :void
  attach_function :gmsec_UnSubscribe, [self, :string, GMSEC::Status], :void
  attach_function :gmsec_UnSubscribeWCallback, [self, :string, :pointer, GMSEC::Status], :void
  attach_function :gmsec_GetLastDispatcherStatus, [self, GMSEC::Status], :void

  # From ConnectionFactory
  attach_function :gmsec_GetAPIVersion, [], :string
  attach_function :gmsec_CreateConnection, [:GMSEC_CONNECTION_TYPE, GMSEC::Config, :pointer, GMSEC::Status], :void
  attach_function :gmsec_CreateConnectionForType, [:GMSEC_CONNECTION_TYPE, GMSEC::Config, :pointer, GMSEC::Status], :void
  attach_function :gmsec_CreateConnectionForConfig, [GMSEC::Config, :pointer, GMSEC::Status], :void

end
