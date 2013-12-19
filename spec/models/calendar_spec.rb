require 'spec_helper'

describe Calendar do
  it "should have a so_tiet, so_tuan, thu, tiet_bat_dau, tuan_hoc_bat_dau" do
  	lop = FactoryGirl.create(:lop_mon_hoc)
  	calendar = FactoryGirl.create(:calendar, :lop_mon_hoc => lop)
  	calendar.so_tiet.should == 3
  end

  

  it "should belongs to a GiangVien" do 
    lop = FactoryGirl.create(:lop_mon_hoc)
    calendar = FactoryGirl.create(:calendar, :lop_mon_hoc => lop)
    gv = FactoryGirl.create(:giang_vien)
    calendar.should respond_to(:giang_vien)
    calendar.giang_vien = gv
    calendar.giang_vien.should_not be_nil
  end
end
