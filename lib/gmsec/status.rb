class GMSEC::Status
  extend GMSEC::API

  bind GMSEC_STATUS_OBJECT: :status

  attach_function :gmsec_CreateStatus,  [:pointer], :void
  attach_function :gmsec_isStatusError, [self], :int

  def initialize(native_value: nil)
    if native_value
      @native_object = native_value
    end
  end

  def is_error?
    gmsec_isStatusError(self) > 0
  end

  protected

  def status
    @status ||= begin
      pointer = new_pointer
      gmsec_CreateStatus(pointer)
      pointer.read_pointer
    end
  end

end
