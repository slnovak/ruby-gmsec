class GMSEC::Connection
  extend GMSEC::API

  bind GMSEC_MESSAGE_OBJECT: :message

  attach_function :gmsec_CreateConnectionForConfig, [GMSEC::Config, :pointer, GMSEC::Status], :void
  attach_function :gmsec_Connect, [self, GMSEC::Status], :void
  attach_function :gmsec_IsConnected, [self, GMSEC::Status], :int
  attach_function :gmsec_Disconnect, [self, GMSEC::Status], :void
  attach_function :gmsec_DestroyConnection, [self, GMSEC::Status], :void


  attach_function :gmsec_SetMsgKind(self, GMSEC_MSG_KIND kind, GMSEC_STATUS_OBJECT status)
  attach_function :gmsec_GetMsgKind(self, GMSEC_MSG_KIND *kind, GMSEC_STATUS_OBJECT status)
  attach_function :gmsec_SetMsgSubject(self, const char* subject, GMSEC_STATUS_OBJECT status)
  attach_function :gmsec_GetMsgSubject(self, const char* *subject, GMSEC_STATUS_OBJECT status)
  attach_function :gmsec_MsgSetConfig(self, GMSEC_CONFIG_OBJECT config, GMSEC_STATUS_OBJECT status)
  attach_function :gmsec_MsgClearFields(self,GMSEC_STATUS_OBJECT status)
  attach_function :gmsec_MsgAddField(self, GMSEC_FIELD_OBJECT field, GMSEC_STATUS_OBJECT status)
  attach_function :gmsec_MsgClearField(self, const char *name, GMSEC_STATUS_OBJECT status)
  attach_function :gmsec_MsgGetField(self, const char* name, GMSEC_FIELD_OBJECT field, GMSEC_STATUS_OBJECT status)
  attach_function :gmsec_MsgGetFieldCount(self, GMSEC_I32 *count, GMSEC_STATUS_OBJECT status)
  attach_function :gmsec_MsgGetFirstField(self, GMSEC_FIELD_OBJECT field, GMSEC_STATUS_OBJECT status)
  attach_function :gmsec_MsgGetNextField(self, GMSEC_FIELD_OBJECT field, GMSEC_STATUS_OBJECT status)
  attach_function :gmsec_MsgToXML(self, const char **outst, GMSEC_STATUS_OBJECT status)
  attach_function :gmsec_MsgFromXML(self, const char *xml, GMSEC_STATUS_OBJECT status)
  attach_function :gmsec_MsgGetSize(self, GMSEC_U32 *size, GMSEC_STATUS_OBJECT status)
  attach_function :gmsec_MsgGetTime()

  protected

  def message
    @message ||= nil
  end
end
