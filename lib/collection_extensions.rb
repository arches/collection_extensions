require "collection_extensions/version"
require "collection_extensions/cattr"
require "collection_extensions/config"
require "active_record"

class ActiveRecord::Relation
  alias :orig_to_a :to_a
  alias :orig_method_missing :method_missing

  def to_a
    records = orig_to_a

    records.extend extension_module if extension_module

    records
  end

  def extension_module
    extension_klass = CollectionExtensions::Config.naming_convention % @klass.to_s
    if Object.constants.include? extension_klass.to_sym
      Object.const_get(extension_klass)
    end
  end

  def method_missing(method, *args, &block)
    if extension_module and extension_module.method_defined? method
      to_a.send(method, *args, &block)
    else
      orig_method_missing(method, *args, &block)
    end
  end
end
