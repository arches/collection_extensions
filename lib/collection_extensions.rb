require "collection_extensions/version"
require "collection_extensions/cattr"
require "collection_extensions/config"

module CollectionExtensions

  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def extend_collections(*associations)
      Array(associations).each do |association|
        alias_method "orig_#{association}", association

        define_method association do
          upper_camel = association.to_s.split("_").collect{|piece| piece.capitalize}.join
          extender = Object.const_get(CollectionExtensions::Config.naming_convention % upper_camel)
          send("orig_#{association}").extend(extender)
        end
      end
    end
  end

end
