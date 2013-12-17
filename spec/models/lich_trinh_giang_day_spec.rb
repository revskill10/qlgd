require 'spec_helper'

describe LichTrinhGiangDay do  
  it "should be created" do 
  	lop = FactoryGirl.create(:lop_mon_hoc)
  	lich = lop.lich_trinh_giang_days.create(:so_tiet => 2, :thoi_gian => DateTime.new(2013, 8, 12, 6, 30))
  	lich.tiet_bat_dau = lich.get_tiet_bat_dau
  	lich.valid?.should be_true
  	lich.tiet_bat_dau.should == 1
  end

  it "should not be duplicated" do 
  	lop = FactoryGirl.create(:lop_mon_hoc)
  	lich = lop.lich_trinh_giang_days.create(:so_tiet => 2, :thoi_gian => DateTime.new(2013, 8, 12, 6, 30))
  	lich2 = lop.lich_trinh_giang_days.build(:so_tiet => 2, :thoi_gian => DateTime.new(2013, 8, 12, 6, 30))
  	lich2.valid?.should be_false
  end
end
