require 'collection_extensions'

module ExamplesCollectionExtensions
  def operate_on_all_examples
    "operate_on_all_examples"
  end
end

module FoobarsCollectionExtensions
  def operate_on_all_foobars
    "operate_on_all_foobars"
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
    "original examples method"
  end

  def foobars
    "original foobars method"
  end

  extend_collections :examples, :foobars
end

describe CollectionExtensions do
  let(:ct) { CollectionTester.new }

  describe "#extend_collections" do
    it "aliases the examples" do
      ct.orig_examples.should == "original examples method"
      ct.examples.should be_a ExamplesCollectionExtensions
      ct.examples.operate_on_all_examples.should == "operate_on_all_examples"
    end

    it "aliases the foobars" do
      ct.orig_foobars.should == "original foobars method"
      ct.foobars.should be_a FoobarsCollectionExtensions
      ct.foobars.operate_on_all_foobars.should == "operate_on_all_foobars"
    end
  end
end

describe "changing the naming convention" do
  let(:ct) { CollectionTester.new }

  before do
    CollectionTester::Config.naming_convention = "MethodsForCollectionsOf%s"
  end

  it "extends the association with the proper module" do
    ct.orig_examples.should == "original examples method"
    ct.examples.should be_a MethodsForCollectionsOfExamples
    ct.examples.operate_on_all_examples.should == "from a module with a different naming convention"
  end
end

describe "" do

end
