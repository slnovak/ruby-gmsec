module GMSEC::API

  module Finalizer

    # Allows us to specify #destroy! to be called on an instance during GC.
    def initialize(*args, **kwargs)
      ObjectSpace.define_finalizer(self, self.class.method(:destroy!).to_proc)

      # If there is a `native_value` keyword argument supplied, assign
      # the value to native_object
      if native_object = kwargs.delete(:native_object)
        @native_object = native_object
      else
        if respond_to? :native_object_initializer
          initialize_native_object do |pointer|
            native_object_initializer(pointer)
          end
        end
      end

      if kwargs.empty?
        super(*args)
      else
        super(*args, **kwargs)
      end
    end
  end

  def self.extended(base)
    base.extend FFI::Library
    base.extend FFI::DataConverter
    base.send :prepend, Finalizer

    class << base
      def to_native(value, context=nil)
        value.instance_variable_get("@native_object")
      end

      def from_native(value, context=nil)
        new(native_object: value)
      end

      def size
        find_type(native_type).size
      end

      def destroy!(instance)
        if instance.respond_to? :destroy!
          instance.destroy!
        end
      end

      def api_version
        gmsec_GetAPIVersion
      end
    end

    # Load the library for each time the API module is extended.
    base.send(:load_library)
    base.include GMSEC::Definitions
  end

  def bind(object_name, &block)
    native_type find_type(object_name)

    if block_given?
      define_method(:native_object_initializer, &block)
    end

    protected

    # Proxy #find_type through class
    define_method(:find_type) do |type|
      self.class.find_type(type)
    end

    define_method(:initialize_native_object) do |&block|
      instance_eval do
        pointer = FFI::MemoryPointer.new(self.class.native_type)
        block.call(pointer)
        @native_object = pointer.read_pointer
      end
    end

    define_method(:with_string_pointer) do |&block|
      pointer = FFI::MemoryPointer.new :pointer
      block.call(pointer)
      if pointer.read_pointer != nil
        pointer.read_pointer.read_string_to_null
      end
    end
  end

  def has(*objects)
    mapping = {
      config: GMSEC::Config,
      status: GMSEC::Status}

    objects.select{|object| mapping.keys.include? object}.each do |object|
      attr_accessor object

      # Overwrite the getter method to memoize a new instance of the mapped object.
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
        [ '/opt/local/{lib64,lib}',
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

  extend self

  load_library

  def self.api_version
    gmsec_GetAPIVersion
  end

  attach_function :gmsec_GetAPIVersion, [], :string
end
