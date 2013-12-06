require 'spec_helper'

describe User do
  it "should have an imageable sinhvien" do   	
  	sv = FactoryGirl.create(:sinh_vien)
  	us = FactoryGirl.create(:sinhvien)
  	sv.user = us
  	#sv.user.username.should == "sinhvien1@gmail.com" 
  	us.imageable.should be_an(SinhVien)  	
  end 
  it "should have an imageable giangvien" do   	
  	sv = FactoryGirl.create(:giang_vien)
  	us = FactoryGirl.create(:giangvien)
  	sv.user = us
  	#sv.user.username.should == "sinhvien1@gmail.com" 
  	us.imageable.code.should == "gv1"
  end
end
