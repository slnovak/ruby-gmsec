class GMSEC::Message
  extend GMSEC::API
  include Enumerable

  bind GMSEC_MESSAGE_OBJECT: :message

  has :status


  def initialize(data=nil, subject: nil, type: nil, native_value: nil)

    if native_value
      @message = native_value
    end

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

    buffer = FFI::Buffer.new(1024)

    pointer = FFI::MemoryPointer.new(buffer)

    gmsec_GetMsgSubject(self, pointer, status)

    pointer.read_pointer.read_string_to_null unless status.is_error?

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


  def add_field(name, value)

    field = GMSEC::Field.new(name, value)

    gmsec_MsgAddField(self, field, status)

  end


  def clear_field(name)
    gmsec_MsgClearField(self, name, status)
  end


  def [](name)

    field = GMSEC::Field.new

    gmsec_MsgGetField(self, name, field, status)

    field

  end


  def <<(data)
    # We can append a single Field or multiple fields encapsulated as a Hash.

    if data.is_a? GMSEC::Field

      gmsec_MsgAddField(self, data, status)

    elsif data.is_a? Hash

      hash.each do |key, value|
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


  def each(&block)

    field = GMSEC::Field.new

    gmsec_MsgGetFirstField(self, field, status)

    yield field

    (length-1).times do

      gmsec_MsgGetNextField(self, field, status)

      yield field

    end

  end


  def to_xml

    buffer = FFI::Buffer.new(8*1024)

    pointer = FFI::MemoryPointer.new(buffer)

    gmsec_MsgToXml(self, pointer, status)

    pointer.read_pointer.read_string_to_null unless status.is_error?

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


  def message

    @message ||= begin

       pointer = new_pointer

       gmsec_CreateMessage(pointer, status)

       pointer.read_pointer

     end

  end


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
