require 'spec_helper'

describe SinhVien do  
  it "should have a user" do
  	us = FactoryGirl.create(:sinhvien) 
  	sv = FactoryGirl.create(:sinh_vien)
  	sv.user = us
  	sv.user.should be_an(User)
  	us.imageable.should == sv
  end
end
