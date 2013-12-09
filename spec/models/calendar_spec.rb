require 'spec_helper'

describe Calendar do
  it "should have a so_tiet, so_tuan, thu, tiet_bat_dau, tuan_hoc_bat_dau" do
  	lop = FactoryGirl.create(:lop_mon_hoc)
  	calendar = FactoryGirl.create(:calendar, :lop_mon_hoc => lop)
  	calendar.so_tiet.should == 3
  end
end
