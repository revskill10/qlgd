require 'spec_helper'

describe User do
 

  it "should have many lop mon hoc" do 
    
    gv = FactoryGirl.create(:giang_vien)
    us = FactoryGirl.create(:giangvien)
    us.imageable = gv
    us.save
    lop = FactoryGirl.create(:lop_mon_hoc, :giang_vien => gv)
    lop2 = FactoryGirl.create(:lop_mon_hoc, :ma_lop => "ml2", :giang_vien => gv)
    us.imageable.lop_mon_hocs.count.should == 2
    us.hovaten.should == "hogv1 demgv1 tengv1"
  end
end
