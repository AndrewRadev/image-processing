require 'spec_helper'
require 'core_ext/array'

describe Array do
  it "can compute the sum of its contents" do
    [1, 2, 3].sum.should eq 6
    [-1, 1].sum.should eq 0
  end

  it "can compute the average value of its contents as a float value" do
    [1, 2, 3].average.should eq 2
    [-1, 1].average.should eq 0
    [5, 8].average.should eq 6.5
  end
end
