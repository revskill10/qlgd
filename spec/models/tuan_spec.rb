require 'spec_helper'

describe Tuan do
  it "require stt, tu_ngay, den_ngay" do 
  	t = FactoryGirl.build(:tuan, :stt => nil)
  	t.valid?.should be_false
  end
end
