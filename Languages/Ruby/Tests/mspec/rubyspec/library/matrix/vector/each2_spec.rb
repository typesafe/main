require File.dirname(__FILE__) + '/../../../spec_helper'
require 'matrix'

describe "Vector.each2" do
  before :all do
    @v = Vector[1, 2, 3]
    @v2 = Vector[4, 5, 6]
  end

  it "requires one argument" do
    lambda { @v.each2(@v2, @v2){} }.should raise_error(ArgumentError)
    lambda { @v.each2(){} }.should raise_error(ArgumentError)
  end

  describe "given one argument" do
    ruby_bug "redmine:2495", "1.9.1" do
      it "requires the argument to be a Vector or an Array" do
        lambda { @v.each2(5){}        }.should raise_error(TypeError)
        lambda { @v.each2(nil){}      }.should raise_error(TypeError)
      end
    end

    it "accepts an Array argument" do
      a = []
      @v.each2([7, 8, 9]){|x, y| a << x << y}
      a.should == [1, 7, 2, 8, 3, 9]
    end

    it "raises a DimensionMismatch error if the Vector size is different" do
      lambda { @v.each2(Vector[1,2]){}     }.should raise_error(Vector::ErrDimensionMismatch)
      lambda { @v.each2(Vector[1,2,3,4]){} }.should raise_error(Vector::ErrDimensionMismatch)
    end

    it "yields arguments in sequence" do
      a = []
      @v.each2(@v2){|first, second| a << [first, second]}
      a.should == [[1, 4], [2, 5], [3, 6]]
    end

    ruby_bug "to be submitted", "1.9.1" do
      it "yield arguments in pairs" do
        a = []
        @v.each2(@v2){|pair| a << pair}
        a.should == [[1, 4], [2, 5], [3, 6]]
      end
    end

    ruby_bug "to be submitted", "1.9.1" do
      it "returns self when given a block" do
        @v.each2(@v2){}.should equal(@v)
      end
    end

    ruby_version_is "1.9" do
      it "returns an enumerator if no block given" do
        enum = @v.each2(@v2)
        enum.should be_kind_of(enumerator_class)
        enum.to_a.should == [[1, 4], [2, 5], [3, 6]]
      end
    end
  end
end