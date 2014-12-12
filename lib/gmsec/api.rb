module GMSEC::API

  extend ::FFI::Library

  def search_paths
    @search_paths ||= begin
      if ENV['GMSEC_LIBRARY_PATH']
        ENV['GMSEC_LIBRARY_PATH']
      elsif FFI::Platform.windows?
        ENV['PATH'].split(File::PATH_SEPARATOR)
      else
        [
          '/opt/local/{lib64,lib}',
          '/opt/local/{lib64,lib}',
          '/usr/lib/{x86_64,i386}-linux-gnu',
          '/usr/local/{lib64,lib}',
          '/usr/{lib64,lib}']
      end
    end
  end

  def find_lib(lib)
    if ENV['GMSEC_LIBRARY_PATH'] && File.file?(ENV['GMSEC_LIBRARY_PATH'])
      ENV['GMSEC_LIBRARY_PATH']
    else
      Dir.glob(search_paths.map {|path|
        File.expand_path(File.join(path, "#{lib}.#{FFI::Platform::LIBSUFFIX}"))
      }).first
    end
  end

  def gmsec_library_path
    @gmsec_library_path ||= begin
      find_lib('{lib,}GMSECAPI{,-?}')
    end
  end

  def load_lib
    self.ffi_lib gmsec_library_path 
  end

  def bind!(object_name)
    if self.is_a? FFI::DataConverter
      native_type GMSEC::API.find_type(object_name)
    end
  end

  def extended(base)
    # Load the library for each time the API module is extended.
    base.load_lib

    class << base
      def to_native(value, context)
        value.native_object
      end

      def from_native(value, context)
        new(native_value: value)
      end

      def size
        find_type(native_type).size
      end
    end
  end

  # Take all methods in this module and make them extenable to classes.
  extend self

  # Load in GMSEC definitions into this module.
  require 'gmsec/api_definitions'

end
