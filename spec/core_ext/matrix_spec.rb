require 'spec_helper'
require 'core_ext/matrix'

describe Matrix do
  it "can calculate the sum of its elements" do
    Matrix[ [1, 2], [3, 4] ].sum.should eq 10
    Matrix[ [1, -1], [0, 1] ].sum.should eq 1
  end

  it "can calculate the average value of its elements" do
    Matrix[ [1, 2], [3, 4] ].average.should eq 2.5
    Matrix[ [1, 1], [1, 1] ].average.should eq 1
  end

  it "can find the median of its elements" do
    Matrix[ [1, 2], [3, 2] ].median.should eq 2
    Matrix[ [-1, -1], [3, 10] ].median.should eq 3
  end
end
