class GMSEC::Message
  extend GMSEC::API

  has :status

  bind :GMSEC_MESSAGE_OBJECT

  def load_fields_from_config_file(config_file, message_name)
    config_file.get_message(message_name, message: self)
  end

  def type
    pointer = FFI::MemoryPointer.new(find_type(:GMSEC_MSG_KIND))
    gmsec_GetMsgKind(self, pointer, status)

    if status.is_error?
      raise RuntimeError.new("Error getting message type: #{status}")
    end

    case pointer.read_ushort
    when GMSEC_MSG_PUBLISH
      :publish
    when GMSEC_MSG_REPLY
      :reply
    when GMSEC_MSG_REQUEST
      :request
    when GMSEC_MSG_UNSET
      :unset
    else
      raise TypeError.new("Unrecognized GMSEC data type")
    end
  end

  def type=(type)
    value = case type
            when :publish
              GMSEC_MSG_PUBLISH
            when :reply
              GMSEC_MSG_REPLY
            when :request
              GMSEC_MSG_REQUEST
            when :unset
              GMSEC_MSG_REQUEST
            else
              raise TypeError.new("#{type} is not supported as a GMSEC type.")
            end

    gmsec_SetMsgKind(self, value, status)

    if status.is_error?
      raise RuntimeError.new("Error setting message type: #{status}")
    end
  end

  def subject
    with_string_pointer do |pointer|
      gmsec_GetMsgSubject(self, pointer, status)

      if status.is_error?
        raise RuntimeError.new("Error getting message subject: #{status}")
      end
    end
  end

  def subject=(subject)
    gmsec_SetMsgSubject(self, subject, status)

    if status.is_error?
      raise RuntimeError.new("Error setting message subject: #{status}")
    end
  end

  def config=(config)
    gmsec_MsgSetConfig(self, config, status)

    if status.is_error?
      raise RuntimeError.new("Error setting message config: #{status}")
    end
  end

  def clear_fields
    gmsec_MsgClearFields(self, status)

    if status.is_error?
      raise RuntimeError.new("Error clearing message fields: #{status}")
    end
  end

  def clear_field(name)
    gmsec_MsgClearField(self, name.to_s, status)

    if status.is_error?
      raise RuntimeError.new("Error clearing message field: #{status}")
    end
  end

  def [](name)
    field = GMSEC::Field.new
    gmsec_MsgGetField(self, name.to_s, field, status)

    case status.code
    when GMSEC_STATUS_NO_ERROR
      field.value
    when !GMSEC_INVALID_FIELD_NAME
      raise RuntimeError.new("Error getting message field: #{status}")
    end
  end

  def []=(name, value)
    self << GMSEC::Field.new(name, value)
  end

  def <<(data)
    # We can append a single Field or multiple fields encapsulated as a Hash.
    if data.is_a? GMSEC::Field
      gmsec_MsgAddField(self, data, status)
    elsif data.is_a? Hash
      data.each do |key, value|
        self << GMSEC::Field.new(key, value)
      end
    elsif data
      raise TypeError.new("#{data.class} is not supported as a GMSEC field type.")
    end

    if status.is_error?
      raise RuntimeError.new("Error adding data to message: #{status}")
    end
  end

  def length
    pointer = FFI::MemoryPointer.new(find_type(:GMSEC_I32))
    gmsec_MsgGetFieldCount(self, pointer, status)
    pointer.read_int32
  end

  def fields
    Enumerator.new do |y|
      field = GMSEC::Field.new
      gmsec_MsgGetFirstField(self, field, status)

      while status.code != GMSEC_FIELDS_END_REACHED && status.code == GMSEC_STATUS_NO_ERROR
        y << field
        gmsec_MsgGetNextField(self, field, status)
      end

      unless status.code == GMSEC_FIELDS_END_REACHED
        raise RuntimeError.new("Error reading message fields: #{status}")
      end
    end
  end

  def to_s
    ::Terminal::Table.new(title: subject, rows: to_h)
  end

  def to_h
    Hash[fields.map{|field| [field.name, field.value]}]
  end

  def to_xml
    with_string_pointer do |pointer|
      gmsec_MsgToXML(self, pointer, status)

      if status.is_error?
        raise RuntimeError.new("Error converting message to xml: #{status}")
      end
    end
  end

  def from_xml(xml)
    gmsec_MsgFromXML(self, xml, status).tap do |_|
      if status.is_error?
        raise RuntimeError.new("Error converting xml to message: #{status}")
      end
    end
  end

  def size
    pointer = FFI::MemoryPointer.new(find_type(:GMSEC_U32))
    gmsec_MsgGetSize(self, pointer, status)
    pointer.read_uint32
  end

  def time
    gmsec_MsgGetTime
  end

  def valid?
    gmsec_isMsgValid(self) == self.class.enum_type(:GMSEC_BOOL)[:GMSEC_TRUE]
  end

  protected

  attach_function :gmsec_SetMsgKind, [self, :GMSEC_MSG_KIND, GMSEC::Status], :void
  attach_function :gmsec_GetMsgKind, [self, :pointer, GMSEC::Status], :void
  attach_function :gmsec_SetMsgSubject, [self, :string, GMSEC::Status], :void
  attach_function :gmsec_GetMsgSubject, [self, :pointer, GMSEC::Status], :void
  attach_function :gmsec_MsgSetConfig, [self, GMSEC::Config, GMSEC::Status], :void
  attach_function :gmsec_MsgClearFields, [self, GMSEC::Status], :void
  attach_function :gmsec_MsgAddField, [self, GMSEC::Field, GMSEC::Status], :void
  attach_function :gmsec_MsgClearField, [self, :string, GMSEC::Status], :void
  attach_function :gmsec_MsgGetField, [self, :string, GMSEC::Field, GMSEC::Status], :void
  attach_function :gmsec_MsgGetFieldCount, [self, :pointer, GMSEC::Status], :void
  attach_function :gmsec_MsgGetFirstField, [self, GMSEC::Field, GMSEC::Status], :void
  attach_function :gmsec_MsgGetNextField, [self, GMSEC::Field, GMSEC::Status], :void
  attach_function :gmsec_MsgToXML, [self, :pointer, GMSEC::Status], :void
  attach_function :gmsec_MsgFromXML, [self, :string, GMSEC::Status], :void
  attach_function :gmsec_MsgGetSize, [self, :pointer, GMSEC::Status], :void
  attach_function :gmsec_MsgGetTime, [], :string
  attach_function :gmsec_isMsgValid, [self], :int
end
