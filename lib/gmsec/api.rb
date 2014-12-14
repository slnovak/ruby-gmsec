module GMSEC::API

  def self.extended(base)
    base.extend FFI::Library
    base.extend FFI::DataConverter


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

    # Load the library for each time the API module is extended.
    base.send(:load_library)

    base.include GMSEC::Definitions
  end


  def bind(opts)

    object_name, attr = opts.to_a.first

    native_type find_type(object_name)

    # Delegate native_object to `attr`
    define_method(:native_object) do
      self.send(attr)
    end

    # Create a new pointer to an instance of the class.
    define_method(:new_pointer) do
      FFI::MemoryPointer.new(self.class.native_type)
    end

    # Proxy #find_type through class
    define_method(:find_type) do |type|
      self.class.find_type(type)
    end

  end


  def has(*objects)
    # Allows to automatically add protected methods for objects like Config, Status, etc.
    #
    # Example:
    #
    # has :status, :config

    mapping = {
      config: GMSEC::Config,
      status: GMSEC::Status }

    objects.select{|object| mapping.keys.include? object}.each do |object|

      define_method(object) do

        name = "@#{object}"

        instance_variable_set(name, instance_variable_get(name) || mapping[object].new)

      end
    end
  end


  protected


  def load_library
    self.ffi_lib gmsec_library_path 
  end


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
end
