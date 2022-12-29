require 'spec_helper'

describe User do
 

  it "should have many lop mon hoc" do 
    
    gv = FactoryGirl.create(:giang_vien)
    us = FactoryGirl.create(:giangvien)
    us.imageable = gv
    us.save    
    us.hovaten.should == "hogv1 demgv1 tengv1"
  end
end
