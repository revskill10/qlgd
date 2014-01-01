require 'spec_helper'

describe Tuan do
  it "require stt, tu_ngay, den_ngay" do 
  	t = FactoryGirl.build(:tuan, :stt => nil)
  	t.valid?.should be_false
  end
  it "could be created" do 
  	t = Tuan.create(stt: 1, tu_ngay: Date.new(2013, 8, 12), den_ngay: Date.new(2013, 8, 15))
  	t.tu_ngay.should eq(Date.new(2013, 8, 12))
  end
end
