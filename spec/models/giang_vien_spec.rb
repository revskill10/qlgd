require 'spec_helper'

describe GiangVien do
  it "should have a user" do
  	us = FactoryGirl.create(:giangvien) 
  	gv = FactoryGirl.create(:giang_vien, :user => us)  	
  	gv.user.should be_an(User)
  	gv.user.username.should == 'trungth@hpu.edu.vn'
  	us.imageable.should be_a(GiangVien)
  end
end
