module CollectionExtensions
  class Config
    cattr_accessor :naming_convention

    DEFAULT_NAMING_CONVENTION = "%sCollectionExtensions"

    @@naming_convention = DEFAULT_NAMING_CONVENTION
  end
end
