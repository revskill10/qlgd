require 'spec_helper'

describe GiangVien do
  it "should have a user" do
  	us = FactoryGirl.create(:giangvien) 
  	gv = FactoryGirl.create(:giang_vien)
  	gv.user = us
  	gv.save
  	#gv.save
  	gv.user.should be_an(User)
  	gv.user.username.should == 'trungth@hpu.edu.vn'
  	us.imageable.should be_a(GiangVien)
  	us.imageable.should == gv
  end
end
