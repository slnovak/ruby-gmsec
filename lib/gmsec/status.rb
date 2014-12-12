class GMSEC::Status
  extend FFI::Library
  extend FFI::DataConverter
  extend GMSEC::API

  bind! :GMSEC_STATUS_OBJECT

  attach_function :gmsec_CreateStatus,  [:pointer], :void
  attach_function :gmsec_isStatusError, [self], :int

  def initialize(native_value: nil)
    if native_value
      @native_object = native_value
    end
  end

  def native_object
    @native_object ||= begin
      ptr = FFI::MemoryPointer.new(self.class.native_type)
      gmsec_CreateStatus(ptr)
      ptr.read_pointer
    end
  end

  def is_error?
    gmsec_isStatusError(self) > 0
  end

end
