class GMSEC::Config
  extend FFI::Library
  extend FFI::DataConverter
  extend GMSEC::API

  bind! :GMSEC_CONFIG_OBJECT

  attach_function :gmsec_CreateConfig, [:pointer, GMSEC::Status], :void
  attach_function :gmsec_ConfigAddValue, [self, :string, :string, GMSEC::Status], :void
  attach_function :gmsec_ConfigGetValue, [self, :string, :pointer, GMSEC::Status], :void

  attr_reader :native_object

  def initialize(options={}, native_value: nil)
    if native_value
      @native_object = native_value
    end

    options.each do |key, value|
      add_value(key, value)
    end
  end

  def native_object
    @native_object ||= begin
      ptr = FFI::MemoryPointer.new(self.class.native_type)
      gmsec_CreateConfig(ptr, status)
      ptr.read_pointer
    end
  end

  def [](key)
    get_value(key)
  end

  def []=(key, value)
    add_value(key, value)
  end

  protected

  def status
    @status ||= GMSEC::Status.new
  end

  def add_value(key, value)
    gmsec_ConfigAddValue(self, key.to_s, value.to_s, status)
  end

  def get_value(key)
    buffer = FFI::Buffer.new(1024)
    ptr = FFI::MemoryPointer.new(buffer)
    gmsec_ConfigGetValue(self, key.to_s, ptr, status)
    ptr.read_pointer.read_string_to_null unless status.is_error?
  ensure
    buffer.clear
  end

end
