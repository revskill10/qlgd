require 'spec_helper'

describe GiangVien do
  it "should have a user" do
  	us = FactoryGirl.create(:giangvien) 
  	sv = FactoryGirl.create(:giang_vien)
  	sv.user = us
  	sv.user.should be_an(User)
  end
end
