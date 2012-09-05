require 'active_record'
require 'collection_extensions'

module UserCollectionExtensions
  def utest
    "ufoo"
  end
end

module ExtensionMethodsForUserCollections
end

describe "#extension_class" do
  context "when the extension module exists" do
    it "returns the constant" do
      r = ActiveRecord::Relation.new :User, :users
      r.extension_module.should == UserCollectionExtensions
    end
  end

  context "when the extension module doesn't exist" do
    it "returns nil" do
      r = ActiveRecord::Relation.new :Order, :orders
      r.extension_module.should be_nil
    end
  end

  context "when the naming convention has been changed" do
    before { CollectionExtensions::Config.naming_convention = "ExtensionMethodsForUserCollections" }
    after { CollectionExtensions::Config.naming_convention = CollectionExtensions::Config::DEFAULT_NAMING_CONVENTION }

    it "uses the proper convention to return the constant" do
      r = ActiveRecord::Relation.new :User, :users
      r.extension_module.should == ExtensionMethodsForUserCollections
    end
  end
end

describe "calling methods on the array" do
  it "pulls extension methods from the module" do
    r = ActiveRecord::Relation.new :User, :users
    r.stub(orig_to_a: [])
    r.to_a.utest.should == "ufoo"
  end
end

describe "calling methods on the relation" do
  it "pulls extension methods from the module" do
    r = ActiveRecord::Relation.new :User, :users
    r.stub(orig_to_a: [])
    r.utest.should == "ufoo"
  end

  it "lets non-extension methods pass through" do
    r = ActiveRecord::Relation.new :User, :users
    r.stub(orig_to_a: ['first'])
    r.first.should == 'first'
  end

  context "when the extension module doesn't exist" do
    it "lets methods pass through" do
      r = ActiveRecord::Relation.new :Order, :orders
      r.stub(orig_to_a: ['first'])
      r.first.should == 'first'
    end
  end
end
