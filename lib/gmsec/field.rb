class GMSEC::Field
  extend GMSEC::API

  bind GMSEC_FIELD_OBJECT: :field

  has :status


  attach_function :gmsec_CreateField, [:pointer, GMSEC::Status], :void
  attach_function :gmsec_DestroyField, [:pointer, GMSEC::Status], :void
  attach_function :gmsec_GetFieldName, [self, :pointer, GMSEC::Status], :void
  attach_function :gmsec_SetFieldName, [self, :string, GMSEC::Status], :void
  attach_function :gmsec_SetFieldType, [self, :GMSEC_TYPE, GMSEC::Status], :void
  attach_function :gmsec_GetFieldType, [self, :pointer, GMSEC::Status], :void
  attach_function :gmsec_GetFieldValueCHAR, [self, :pointer, GMSEC::Status], :void
  attach_function :gmsec_GetFieldValueBOOL, [self, :pointer, GMSEC::Status], :void
  attach_function :gmsec_GetFieldValueSHORT, [self, :pointer, GMSEC::Status], :void
  attach_function :gmsec_GetFieldValueUSHORT, [self, :pointer, GMSEC::Status], :void
  attach_function :gmsec_GetFieldValueLONG, [self, :pointer, GMSEC::Status], :void
  attach_function :gmsec_GetFieldValueULONG, [self, :pointer, GMSEC::Status], :void
  attach_function :gmsec_GetFieldValueFLOAT, [self, :pointer, GMSEC::Status], :void
  attach_function :gmsec_GetFieldValueDOUBLE, [self, :pointer, GMSEC::Status], :void
  attach_function :gmsec_GetFieldValueSTRING, [self, :pointer, GMSEC::Status], :void
  attach_function :gmsec_GetFieldValueSTR, [self, :pointer, GMSEC::Status], :void
  attach_function :gmsec_GetFieldValueI16, [self, :pointer, GMSEC::Status], :void
  attach_function :gmsec_GetFieldValueU16, [self, :pointer, GMSEC::Status], :void
  attach_function :gmsec_GetFieldValueI32, [self, :pointer, GMSEC::Status], :void
  attach_function :gmsec_GetFieldValueU32, [self, :pointer, GMSEC::Status], :void
  attach_function :gmsec_GetFieldValueF32, [self, :pointer, GMSEC::Status], :void
  attach_function :gmsec_GetFieldValueF64, [self, :pointer, GMSEC::Status], :void
  attach_function :gmsec_GetFieldValueSTRING, [self, :pointer, GMSEC::Status], :void
  attach_function :gmsec_GetFieldValueI64, [self, :pointer, GMSEC::Status], :void
  attach_function :gmsec_SetFieldValueCHAR, [self, :GMSEC_CHAR, GMSEC::Status], :void
  attach_function :gmsec_SetFieldValueBOOL, [self, :GMSEC_BOOL, GMSEC::Status], :void
  attach_function :gmsec_SetFieldValueSHORT, [self, :GMSEC_SHORT, GMSEC::Status], :void
  attach_function :gmsec_SetFieldValueUSHORT, [self, :GMSEC_USHORT, GMSEC::Status], :void
  attach_function :gmsec_SetFieldValueLONG, [self, :GMSEC_LONG, GMSEC::Status], :void
  attach_function :gmsec_SetFieldValueULONG, [self, :GMSEC_ULONG, GMSEC::Status], :void
  attach_function :gmsec_SetFieldValueFLOAT, [self, :GMSEC_FLOAT, GMSEC::Status], :void
  attach_function :gmsec_SetFieldValueDOUBLE, [self, :GMSEC_DOUBLE, GMSEC::Status], :void
  attach_function :gmsec_SetFieldValueSTRING, [self, :GMSEC_STR, GMSEC::Status], :void
  attach_function :gmsec_SetFieldValueSTR, [self, :GMSEC_STR, GMSEC::Status], :void
  attach_function :gmsec_SetFieldValueI16, [self, :GMSEC_I16, GMSEC::Status], :void
  attach_function :gmsec_SetFieldValueU16, [self, :GMSEC_U16, GMSEC::Status], :void
  attach_function :gmsec_SetFieldValueI32, [self, :GMSEC_I32, GMSEC::Status], :void
  attach_function :gmsec_SetFieldValueU32, [self, :GMSEC_U32, GMSEC::Status], :void
  attach_function :gmsec_SetFieldValueF32, [self, :GMSEC_F32, GMSEC::Status], :void
  attach_function :gmsec_SetFieldValueF64, [self, :GMSEC_F64, GMSEC::Status], :void
  attach_function :gmsec_SetFieldValueI64, [self, :GMSEC_I64, GMSEC::Status], :void
  attach_function :gmsec_UnSetField, [self, GMSEC::Status], :void
  attach_function :gmsec_LookupFieldType, [:string], :GMSEC_TYPE


  # Map GMSEC values to deftypes
  GMSEC_TYPEDEF = {
    GMSEC_TYPE_BOOL   => :bool,
    GMSEC_TYPE_CHAR   => :char,
    GMSEC_TYPE_DOUBLE => :double,
    GMSEC_TYPE_F32    => :f32,
    GMSEC_TYPE_F64    => :f64,
    GMSEC_TYPE_FLOAT  => :float,
    GMSEC_TYPE_I16    => :i16,
    GMSEC_TYPE_I32    => :i32,
    GMSEC_TYPE_LONG   => :long,
    GMSEC_TYPE_SHORT  => :short,
    GMSEC_TYPE_STR    => :str,
    GMSEC_TYPE_U16    => :u16,
    GMSEC_TYPE_U32    => :u32,
    GMSEC_TYPE_ULONG  => :ulong,
    GMSEC_TYPE_UNSET  => :unset,
    GMSEC_TYPE_USHORT => :ushort }


  TYPE_TO_GMSEC_VALUE = {
    bool:    GMSEC_TYPE_BOOL,
    char:    GMSEC_TYPE_CHAR,
    double:  GMSEC_TYPE_DOUBLE,
    f32:     GMSEC_TYPE_F32,
    f64:     GMSEC_TYPE_F64,
    float:   GMSEC_TYPE_FLOAT,
    i16:     GMSEC_TYPE_I16,
    i32:     GMSEC_TYPE_I32,
    long:    GMSEC_TYPE_LONG,
    short:   GMSEC_TYPE_SHORT,
    str:     GMSEC_TYPE_STR,
    u16:     GMSEC_TYPE_U16,
    u32:     GMSEC_TYPE_U32,
    ulong:   GMSEC_TYPE_ULONG,
    unset:   GMSEC_TYPE_UNSET,
    ushort:  GMSEC_TYPE_USHORT }


  RUBY_TO_GMSEC_TYPE = {
     TrueClass  => :bool,
     FalseClass => :bool,
     String     => :str,
     Fixnum     => :i32,
     Float      => :double }

  
  def initialize(name=nil, value=nil)

    if name
      self.name = name
    end

    if value
      self.value = value
    end

  end


  def name

    buffer = FFI::Buffer.new(1024)

    pointer = FFI::MemoryPointer.new(buffer)

    gmsec_GetFieldName(self, pointer, status)

    pointer.read_pointer.read_string_to_null unless status.is_error?

  ensure

    buffer.clear

  end


  def name=(value)
    gmsec_SetFieldName(self, value.to_s, status)
  end


  def value

    field_type = "GMSEC_#{type.to_s.upcase}".to_sym

    pointer = FFI::MemoryPointer.new(find_type(field_type))

    send(get_field_value_method, self, pointer, status)

    read_pointer_value(pointer)

  end


  def value=(value)

    field_type = RUBY_TO_GMSEC_TYPE[value.class]

    if field_type.nil?
      raise TypeError.new("#{value.class} is not supported as a GMSEC type.")
    end

    self.type = field_type

    send(set_field_value_method(value), self, value, status)

  end


  def type

    # Create a pointer to GMSEC_TYPE that we're going to read and convert to a symbol.
    pointer = FFI::MemoryPointer.new(find_type(:GMSEC_TYPE))

    gmsec_GetFieldType(self, pointer, status)

    # Default to GMSEC_STR if type is not registered in GMSEC_DEF
    GMSEC_TYPEDEF[pointer.read_ushort] || :str

  end


  def type=(value)

    field_type = TYPE_TO_GMSEC_VALUE[type]

    gmsec_SetFieldType(self, field_type, status)

  end


  protected


  def field

    @field ||= begin

       pointer = new_pointer

       gmsec_CreateField(pointer, status)

       pointer.read_pointer

     end

  end


  def set_field_value_method(value)
    # Given a Ruby value, return the name of the corresponding SetFieldValue* method.

    type = RUBY_TO_GMSEC_TYPE[value.class]

    if type.nil?
      raise TypeError.new("#{value.class} is not supported as a GMSEC type.")
    end

    "gmsec_SetFieldValue#{type.to_s.upcase}"

  end


  def get_field_value_method
    "gmsec_GetFieldValue#{type.to_s.upcase.split("_").last}"
  end

  def read_pointer_value(pointer)

    case type
    when :char
      pointer.read_char
    when :bool
      pointer.read_int > 0
    when :short
      pointer.read_short
    when :ushort
      pointer.read_ushort
    when :long
      pointer.read_long
    when :double
      pointer.read_double
    when :str
      pointer.read_pointer.read_string_to_null
    when :i16
      pointer.read_int16
    when :i32
      pointer.read_int32
    when :i64
      pointer.read_int64
    when :u32
      pointer.read_uint32
    when :f32
      pointer.read_float
    when :f64
      pointer.read_double
    else
      raise TypeError.new("#{type} is not a supported type.")
    end

  end
end
