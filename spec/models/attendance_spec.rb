require 'spec_helper'

describe Attendance do
  
  it "requires so_tiet_vang, state, sinh_vien" do 
  	lop = FactoryGirl.create(:lop_mon_hoc)
    gv = FactoryGirl.create(:giang_vien)
    sv = FactoryGirl.create(:sinh_vien)
    lich = lop.lich_trinh_giang_days.create(:so_tiet => 2, :thoi_gian => DateTime.new(2013, 8, 12, 6, 30), :giang_vien_id  => gv.id)
    at = lich.attendances.where(sinh_vien_id: sv.id).first_or_create!
    at.lich_trinh_giang_day.so_tiet.should == 2
    at.state.should == 'pending'
    at.mark_absent(false)
    at.state.should == 'absent'    
    at.so_tiet_vang.should == 2
    at.mark_late(1, true)
    at.state.should == 'late'
    at.so_tiet_vang.should == 1
    at.mark_attendant!
    at.so_tiet_vang.should == 0
    at.mark_idle!
    at.so_tiet_vang.should == 0
  end
end