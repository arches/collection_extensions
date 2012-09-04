require 'collection_extensions'

module ExamplesCollectionExtensions
  def operate_on_all_examples
    "operate_on_all_examples"
  end
end

module MethodsForCollectionsOfExamples
  def operate_on_all_examples
    "from a module with a different naming convention"
  end
end

class CollectionTester
  include CollectionExtensions

  def examples
    "original association method"
  end

  extend_collections :examples
end

describe CollectionExtensions do
  let(:ct) { CollectionTester.new }

  describe "#extend_collection" do
    it "aliases the association" do
      ct.orig_examples.should == "original association method"
      ct.examples.should be_a ExamplesCollectionExtensions
      ct.examples.operate_on_all_examples.should == "operate_on_all_examples"
    end
  end
end

describe "changing the naming convention" do
  let(:ct) { CollectionTester.new }

  before do
    CollectionTester::Config.naming_convention = "MethodsForCollectionsOf%s"
  end

  it "extends the association with the proper module" do
    ct.orig_examples.should == "original association method"
    ct.examples.should be_a MethodsForCollectionsOfExamples
    ct.examples.operate_on_all_examples.should == "from a module with a different naming convention"
  end
end
