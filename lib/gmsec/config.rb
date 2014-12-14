class GMSEC::Config
  extend GMSEC::API

  bind GMSEC_CONFIG_OBJECT: :config

  has :status


  attach_function :gmsec_CreateConfig, [:pointer, GMSEC::Status], :void
  attach_function :gmsec_ConfigAddValue, [self, :string, :string, GMSEC::Status], :void
  attach_function :gmsec_ConfigGetValue, [self, :string, :pointer, GMSEC::Status], :void


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


  protected


  def config

    @config ||= begin

      pointer = new_pointer

      gmsec_CreateConfig(pointer, status)

      pointer.read_pointer

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
end
