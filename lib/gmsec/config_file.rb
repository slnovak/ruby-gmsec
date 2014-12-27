require 'pry'
class GMSEC::ConfigFile
  extend GMSEC::API

  has :status

  bind :GMSEC_CONFIGFILE_OBJECT

  def initialize(filename)
    initialize_native_object do |pointer|
      gmsec_CreateConfigFile(pointer, filename, status)
    end

    gmsec_LoadConfigFile(self, status)

    if status.is_error?
      raise RuntimeError.new("Error reading config file: #{status}")
    end
  end

  def to_xml
    with_string_pointer do |pointer|
      gmsec_ToXMLConfigFile(self, pointer, status)
    end
  end

  def from_xml(str)
    gmsec_FromXMLConfigFile(self, str, status)
  end

  def get_config(config_name)
    GMSEC::Config.new.tap do |config|
      gmsec_LookupConfigFileConfig(self, config_name, config, status)
    end
  end

  def get_message(message_name, message: GMSEC::Message.new)
    message.tap do |message|
      gmsec_LookupConfigFileMessage(self, message_name, message, status)
    end
  end

  def get_subscription(subscription_name)
    with_string_pointer do |pointer|
      gmsec_LookupConfigFileSubscription(self, subscription_name, pointer, status)
    end
  end

  attach_function :gmsec_CreateConfigFile, [:pointer, :string, GMSEC::Status], :void
  attach_function :gmsec_DestroyConfigFile, [:pointer, GMSEC::Status], :void
  attach_function :gmsec_LoadConfigFile, [self, GMSEC::Status], :void
  attach_function :gmsec_FromXMLConfigFile, [self, :string, GMSEC::Status], :void
  attach_function :gmsec_ToXMLConfigFile, [self, :pointer, GMSEC::Status], :void
  attach_function :gmsec_LookupConfigFileConfig, [self, :string, GMSEC::Config, GMSEC::Status], :void
  attach_function :gmsec_LookupConfigFileMessage, [self, :string, GMSEC::Message, GMSEC::Status], :void
  attach_function :gmsec_LookupConfigFileSubscription, [self, :string, :pointer, GMSEC::Status], :void
end
