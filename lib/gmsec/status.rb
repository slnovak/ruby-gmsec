class GMSEC::Status
  extend GMSEC::API

  bind :GMSEC_STATUS_OBJECT do |pointer|
    gmsec_CreateStatus(pointer)
  end


  def is_error?
    gmsec_isStatusError(self) > 0
  end


  def to_s
    gmsec_GetStatusString(self)
  end


  def code
    gmsec_GetStatusCode(self)
  end


  protected


  attach_function :gmsec_CreateStatus, [:pointer], :void
  attach_function :gmsec_DestroyStatus, [:pointer], :void
  attach_function :gmsec_GetStatus, [self], :string
  attach_function :gmsec_GetStatusString, [self], :string
  attach_function :gmsec_GetStatusClass, [self], find_type(:GMSEC_STATUS_CLASS)
  attach_function :gmsec_GetStatusCode, [self], :uint
  attach_function :gmsec_GetStatusCustomCode, [self], :int
  attach_function :gmsec_isStatusError, [self], :int

end
