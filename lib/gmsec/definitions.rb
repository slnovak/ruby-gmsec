module GMSEC::Definitions

  GMSEC_AUTODISPATCH_EXCLUSIVE      = 37
  GMSEC_AUTODISPATCH_FAILURE        = 2
  GMSEC_BAD_MESSAGE_FORMAT          = 33
  GMSEC_CONFIG_END_REACHED          = 6
  GMSEC_CONNECTION_DISPATCHER_ERROR = "CONNECTION_DISPATCHER_ERROR"
  GMSEC_CONNECTION_ICSSWB           = 1
  GMSEC_CONNECTION_RENDEZVOUS       = 2
  GMSEC_CONNECTION_REQUEST_TIMEOUT  = "CONNECTION_REQUEST_TIMEOUT"
  GMSEC_CONNECTION_SMARTSOCKETS     = 3
  GMSEC_CUSTOM_ERROR                = 36
  GMSEC_ENCODING_ERROR              = 26
  GMSEC_FEATURE_NOT_SUPPORTED       = 4
  GMSEC_FIELDS_END_REACHED          = 9
  GMSEC_FIELD_TYPE_MISMATCH         = 10
  GMSEC_INITIALIZATION_ERROR        = 29
  GMSEC_INVALID_CALLBACK            = 12
  GMSEC_INVALID_CONFIG              = 25
  GMSEC_INVALID_CONFIG_NAME         = 17
  GMSEC_INVALID_CONFIG_VALUE        = 5
  GMSEC_INVALID_CONNECTION          = 3
  GMSEC_INVALID_CONNECTION_TYPE     = 1
  GMSEC_INVALID_FIELD               = 23
  GMSEC_INVALID_FIELD_NAME          = 15
  GMSEC_INVALID_FIELD_VALUE         = 16
  GMSEC_INVALID_MESSAGE             = 7
  GMSEC_INVALID_NEXT                = 28
  GMSEC_INVALID_SIGNATURE           = 34
  GMSEC_INVALID_SUBJECT_NAME        = 18
  GMSEC_LIBRARY_LOAD_FAILURE        = 0
  GMSEC_MSGCONVERT_FAILURE          = 14
  GMSEC_MSG_PUBLISH                 = 1
  GMSEC_MSG_REPLY                   = 3
  GMSEC_MSG_REQUEST                 = 2
  GMSEC_MSG_UNSET                   = 0
  GMSEC_NO_MESSAGE_AVAILABLE        = 19
  GMSEC_NO_WAIT                     = 0
  GMSEC_OTHER_ERROR                 = 50
  GMSEC_OUT_OF_MEMORY               = 27
  GMSEC_PUBLISH_NOT_AUTHORIZED      = 31
  GMSEC_REQDISPATCH_FAILURE         = 13
  GMSEC_STATUS_CALLBACKLKP_ERROR    = 8
  GMSEC_STATUS_CALLBACK_ERROR       = 7
  GMSEC_STATUS_CONFIGFILE_ERROR     = 9
  GMSEC_STATUS_CONFIG_ERROR         = 3
  GMSEC_STATUS_CONNECTION_ERROR     = 2
  GMSEC_STATUS_CUSTOM_ERROR         = 12
  GMSEC_STATUS_FACTORY_ERROR        = 1
  GMSEC_STATUS_FIELD_ERROR          = 6
  GMSEC_STATUS_ITERATOR_ERROR       = 10
  GMSEC_STATUS_LIBRARY_ERROR        = 4
  GMSEC_STATUS_MESSAGE_ERROR        = 5
  GMSEC_STATUS_NO_ERROR             = 0
  GMSEC_STATUS_OTHER_ERROR          = 20
  GMSEC_STATUS_POLICY_ERROR         = 11
  GMSEC_SUBSCRIBE_NOT_AUTHORIZED    = 32
  GMSEC_TIMEOUT_OCCURRED            = 20
  GMSEC_TRACKING_FAILURE            = 21
  GMSEC_TYPE_BLOB                   = 10
  GMSEC_TYPE_BOOL                   = 2
  GMSEC_TYPE_CHAR                   = 1
  GMSEC_TYPE_COMPOUND               = 24
  GMSEC_TYPE_F32                    = 7
  GMSEC_TYPE_F64                    = 8
  GMSEC_TYPE_I16                    = 3
  GMSEC_TYPE_I32                    = 5
  GMSEC_TYPE_I64                    = 22
  GMSEC_TYPE_I8                     = 20
  GMSEC_TYPE_STR                    = 9
  GMSEC_TYPE_U16                    = 4
  GMSEC_TYPE_U32                    = 6
  GMSEC_TYPE_U64                    = 23
  GMSEC_TYPE_U8                     = 21
  GMSEC_TYPE_UNSET                  = 0
  GMSEC_UNINITIALIZED_OBJECT        = 35
  GMSEC_UNKNOWN_FIELD_TYPE          = 11
  GMSEC_UNKNOWN_MSG_TYPE            = 8
  GMSEC_UNUSED_CONFIG_ITEM          = 22
  GMSEC_USER_ACCESS_INVALID         = 30
  GMSEC_USING_LONG                  = 1
  GMSEC_USING_LONG_LONG             = 1
  GMSEC_USING_SCHAR                 = 1
  GMSEC_USING_SHORT                 = 1
  GMSEC_USING_UCHAR                 = 1
  GMSEC_WAIT_FOREVER                = -1
  GMSEC_XML_PARSE_ERROR             = 24
  MESSAGE_TRACKINGFIELDS_OFF        = :GMSEC_FALSE
  MESSAGE_TRACKINGFIELDS_ON         = :GMSEC_TRUE
  MESSAGE_TRACKINGFIELDS_UNSET      = -1
  NULL                              = 0
  REPLY_SUBJECT_FIELD               = "GMSEC_REPLY_SUBJECT"

  GMSEC_STATUS_MIDDLEWARE_ERROR     = GMSEC_STATUS_LIBRARY_ERROR
  GMSEC_TYPE_BIN                    = GMSEC_TYPE_BLOB
  GMSEC_TYPE_DOUBLE                 = GMSEC_TYPE_F64
  GMSEC_TYPE_FLOAT                  = GMSEC_TYPE_F32
  GMSEC_TYPE_LONG                   = GMSEC_TYPE_I32
  GMSEC_TYPE_SHORT                  = GMSEC_TYPE_I16
  GMSEC_TYPE_STRING                 = GMSEC_TYPE_STR
  GMSEC_TYPE_ULONG                  = GMSEC_TYPE_U32
  GMSEC_TYPE_USHORT                 = GMSEC_TYPE_U16

  # Will specify layout in `included`
  class GMSEC_LOG_ENTRY < FFI::Struct; end
  class GMSEC_CONFIGFILED_STRUCT < FFI::Struct; end
  class GMSEC_CONFIG_STRUCT < FFI::Struct; end
  class GMSEC_CONNECTION_STRUCT < FFI::Struct; end
  class GMSEC_FIELD_STRUCT < FFI::Struct; end
  class GMSEC_MESSAGE_STRUCT < FFI::Struct; end
  class GMSEC_STATUS_STRUCT < FFI::Struct; end

  def self.included(base)

    base.instance_eval do
      typedef :char,        :GMSEC_CHAR
      typedef :char,        :GMSEC_I8
      typedef :double,      :GMSEC_F64
      typedef :float,       :GMSEC_F32
      typedef :long,        :GMSEC_I32
      typedef :long_long,   :GMSEC_I64
      typedef :pointer,     :GMSEC_BIN
      typedef :pointer,     :GMSEC_BLOB
      typedef :pointer,     :GMSEC_CONFIGFILED_OBJECT
      typedef :pointer,     :GMSEC_CONFIGFILE_HANDLE
      typedef :pointer,     :GMSEC_CONFIG_HANDLE
      typedef :pointer,     :GMSEC_CONFIG_OBJECT
      typedef :pointer,     :GMSEC_CONNECTION_HANDLE
      typedef :pointer,     :GMSEC_CONNECTION_OBJECT
      typedef :pointer,     :GMSEC_FIELD_HANDLE
      typedef :pointer,     :GMSEC_FIELD_OBJECT
      typedef :pointer,     :GMSEC_MESSAGE_HANDLE
      typedef :pointer,     :GMSEC_MESSAGE_OBJECT
      typedef :pointer,     :GMSEC_STATUS_HANDLE
      typedef :pointer,     :GMSEC_STATUS_OBJECT
      typedef :pointer,     :GMSEC_STR
      typedef :pointer,     :GMSEC_STRING
      typedef :short,       :GMSEC_I16
      typedef :uchar,       :GMSEC_U8
      typedef :ulong,       :GMSEC_U32
      typedef :ulong_long,  :GMSEC_U64
      typedef :ushort,      :GMSEC_CONNECTION_TYPE
      typedef :ushort,      :GMSEC_STATUS_CLASS
      typedef :ushort,      :GMSEC_TYPE
      typedef :ushort,      :GMSEC_U16

      typedef :GMSEC_F32,   :GMSEC_FLOAT
      typedef :GMSEC_F64,   :GMSEC_DOUBLE
      typedef :GMSEC_I16,   :GMSEC_SHORT
      typedef :GMSEC_I32,   :GMSEC_LONG
      typedef :GMSEC_I64,   :GMSEC_LONGLONG
      typedef :GMSEC_U16,   :GMSEC_MSG_KIND
      typedef :GMSEC_U16,   :GMSEC_USHORT
      typedef :GMSEC_U32,   :GMSEC_ULONG
      typedef :GMSEC_U64,   :GMSEC_ULONGLONG

      enum :GMSEC_BOOL, [
        :GMSEC_FALSE,
        :GMSEC_TRUE
      ] 

      enum :LOG_LEVEL, [
        :logNONE,
        :logERROR,
        :logSECURE,
        :logWARNING,
        :logINFO,
        :logVERBOSE,
        :logDEBUG,
        :logNLEVEL
      ]

      callback :GMSEC_CALLBASE, [:GMSEC_CONNECTION_HANDLE, :GMSEC_MESSAGE_HANDLE], :void
      callback :GMSEC_C_CALLBACK, [:GMSEC_CONNECTION_OBJECT, :GMSEC_MESSAGE_OBJECT], :void
      callback :GMSEC_ERROR_CALLBACK, [:GMSEC_CONNECTION_HANDLE, :GMSEC_MESSAGE_HANDLE, :GMSEC_STATUS_HANDLE, :string], :void
      callback :GMSEC_ERROR_CALLBACK, [:GMSEC_CONNECTION_HANDLE, :GMSEC_MESSAGE_HANDLE, :GMSEC_STATUS_HANDLE, :string], :void
      callback :GMSEC_C_ERROR_CALLBACK, [:GMSEC_CONNECTION_OBJECT, :GMSEC_MESSAGE_OBJECT, :GMSEC_STATUS_OBJECT, :string], :void
      callback :GMSEC_REPLY_CALLBACK, [:GMSEC_CONNECTION_HANDLE, :GMSEC_MESSAGE_HANDLE, :GMSEC_MESSAGE_HANDLE], :void
      callback :GMSEC_C_REPLY_CALLBACK, [:GMSEC_CONNECTION_OBJECT, :GMSEC_MESSAGE_OBJECT, :GMSEC_MESSAGE_OBJECT], :void
      callback :GMSEC_LOGGER_HANDLER, [:pointer], :void
    end

    base::GMSEC_LOG_ENTRY.layout(
      file:     :string,
      line:     :int,
      level:    base.find_type(:LOG_LEVEL),
      time:     :double,
      message:  :string)

  end
end
