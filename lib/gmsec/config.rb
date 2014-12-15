class GMSEC::Config
  extend GMSEC::API

  bind GMSEC_CONFIG_OBJECT: :config

  has :status


  def initialize(options={}, native_value: nil)

    if native_value
      @config = native_value
    end

    options.each do |key, value|
      add_value(key, value)
    end

  end


  def [](key)
    get_value(key)
  end


  def []=(key, value)
    add_value(key, value)
  end


  def values

    Enumerator.new do |y|
      field = GMSEC::Field.new

      key_buffer = FFI::Buffer.new(1024)
      value_buffer = FFI::Buffer.new(8*1024)

      key_pointer = FFI::MemoryPointer.new(key_buffer)
      value_pointer = FFI::MemoryPointer.new(value_buffer)

      gmsec_ConfigGetFirst(self, key_pointer, value_pointer, status)

      key = key_pointer.read_pointer.read_string_to_null unless status.is_error?
      value = value_pointer.read_pointer.read_string_to_null unless status.is_error?

      while status.code == GMSEC_STATUS_NO_ERROR

        y << [key, value]

        gmsec_ConfigGetNext(self, key_pointer, value_pointer, status)

        key = key_pointer.read_pointer.read_string_to_null unless status.is_error?
        value = value_pointer.read_pointer.read_string_to_null unless status.is_error?

      end

    end

  end


  protected


  def config

    @config ||= begin

      @pointer = new_pointer

      gmsec_CreateConfig(@pointer, status)

      @pointer.read_pointer

    end

  end


  def add_value(key, value)

    gmsec_ConfigAddValue(self, key.to_s, value.to_s, status)

    get_value(key)

  end


  def get_value(key)

    buffer = FFI::Buffer.new(1024)

    pointer = FFI::MemoryPointer.new(buffer)

    gmsec_ConfigGetValue(self, key.to_s, pointer, status)

    pointer.read_pointer.read_string_to_null unless status.is_error?

  ensure

    buffer.clear

  end


  attach_function :gmsec_ConfigAddValue, [self, :string, :string, GMSEC::Status], :void
  attach_function :gmsec_ConfigClear, [self, GMSEC::Status], :void
  attach_function :gmsec_ConfigClearValue, [self, :string, GMSEC::Status], :void
  attach_function :gmsec_ConfigFromXML, [self, :string, GMSEC::Status], :void
  attach_function :gmsec_ConfigGetFirst, [self, :pointer, :pointer, GMSEC::Status], :void
  attach_function :gmsec_ConfigGetNext, [self, :pointer, :pointer, GMSEC::Status], :void
  attach_function :gmsec_ConfigGetValue, [self, :string, :pointer, GMSEC::Status], :void
  attach_function :gmsec_ConfigToXML, [self, :pointer, GMSEC::Status], :void
  attach_function :gmsec_CreateConfig, [:pointer, GMSEC::Status], :void
  attach_function :gmsec_CreateConfigParams, [:pointer, :int, :pointer, GMSEC::Status], :void
  attach_function :gmsec_DestroyConfig, [:pointer, GMSEC::Status], :void

end
