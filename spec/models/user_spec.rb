require 'spec_helper'

describe User do
  it "should have an image" do   	
  	sv = FactoryGirl.create(:sinh_vien)
  	us = FactoryGirl.create(:sinhvien)
  	sv.user = us
  	#sv.user.username.should == "sinhvien1@gmail.com" 
  	us.imageable.should be_an(SinhVien)  	
  end 
end
