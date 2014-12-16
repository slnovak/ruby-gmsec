class GMSEC::Message
  extend GMSEC::API

  has :status

  bind :GMSEC_MESSAGE_OBJECT

  def initialize
    @native_object = FFI::MemoryPointer.new(self.class.native_type)
  end

  def type
    pointer = FFI::MemoryPointer.new(find_type(:GMSEC_MSG_KIND))
    gmsec_GetMsgKind(self, pointer, status)

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
  end

  def subject
    with_string_buffer do |pointer|
      gmsec_GetMsgSubject(self, pointer, status)
    end
  end

  def subject=(subject)
    gmsec_SetMsgSubject(self, subject, status)
  end

  def config=(config)
    gmsec_MsgSetConfig(self, config, status)
  end

  def clear_fields
    gmsec_MsgClearFields(self, status)
  end

  def clear_field(name)
    gmsec_MsgClearField(self, name.to_s, status)
  end

  def [](name)
    GMSEC::Field.new.tap do |field|
      gmsec_MsgGetField(self, name.to_s, field, status)
    end
  end

  def <<(data)
    # We can append a single Field or multiple fields encapsulated as a Hash.
    if data.is_a? GMSEC::Field
      gmsec_MsgAddField(self, data, status)
    elsif data.is_a? Hash
      data.each do |key, value|
        self << GMSEC::Field.new(key, value)
      end
    else
      raise TypeError.new("#{data.class} is not supported as a GMSEC field type.")
    end
  end

  def length
    length = 0
    pointer = FFI::MemoryPointer.new(length)
    gmsec_MsgGetFieldCount(self, pointer, status)
  end

  def fields
    Enumerator.new do |y|
      field = GMSEC::Field.new
      gmsec_MsgGetFirstField(self, field, status)
      while 
        y << field
        gmsec_MsgGetNextField(self, field, status)
      end
    end
  end

  def to_h
    Hash[fields.map{|field| [field.key, field.value]}]
  end

  def to_xml
    with_string_buffer(8*1024) do |pointer|
      gmsec_MsgToXML(self, pointer, status)
    end
  end

  def from_xml(xml)
    gmsec_MsgFromXML(self, xml, status)
  end

  def size
    pointer = FFI::MemoryPointer.new(find_type(:GMSEC_U32))
    gmsec_MsgGetSize(self, pointer, status)
    pointer.read_uint32
  end

  def time
    gmsec_MsgGetTime
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
end
