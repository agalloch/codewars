require "spec"
require "../src/next_smaller"

describe "#next_smaller" do
  it "returns next number" do
    next_smaller(907).should eq 790
    next_smaller(531).should eq 513
    next_smaller(2071).should eq 2017
    next_smaller(414).should eq 144
    next_smaller(123_456_798).should eq 123_456_789
    next_smaller(1_234_567_908).should eq 1_234_567_890
  end

  it "cannot find next number" do
    next_smaller(135).should eq -1
    next_smaller(123_456_789).should eq -1
  end
end
