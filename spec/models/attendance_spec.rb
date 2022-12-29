require 'spec_helper'

describe Attendance do
  
  it "requires so_tiet_vang, state, sinh_vien" do
    t1 = FactoryGirl.create(:tuan, :stt => 1, :tu_ngay => Date.new(2013, 8, 12).change(:offset => Rational(7,24)), :den_ngay => Date.new(2013, 8, 18).change(:offset => Rational(7,24)))
    t2 = FactoryGirl.create(:tuan, :stt => 2,  :tu_ngay => Date.new(2013, 8, 19).change(:offset => Rational(7,24)), :den_ngay => Date.new(2013, 8, 25).change(:offset => Rational(7,24)))
    t3 = FactoryGirl.create(:tuan, :stt => 3,  :tu_ngay => Date.new(2013, 8, 26).change(:offset => Rational(7,24)), :den_ngay => Date.new(2013, 8, 31).change(:offset => Rational(7,24)))
    gv = FactoryGirl.create(:giang_vien)    
  	lop = FactoryGirl.create(:lop_mon_hoc)
    gv = FactoryGirl.create(:giang_vien)
    sv = FactoryGirl.create(:sinh_vien)
    lich = lop.lich_trinh_giang_days.with_giang_vien(gv.id).normal.create(:so_tiet => 2, :thoi_gian => Time.new(2013, 8, 12, 6, 30))    
    lich.accept!
    lich.so_tiet_moi.should == 2
    at = lich.attendances.where(sinh_vien_id: sv.id).first_or_create!
    at.lich_trinh_giang_day.so_tiet.should == 2
    at.mark(1, false, false)
    at.so_tiet_vang.should == 1
    at.plus
    at.plus
    at.absent?.should be_true
    at.so_tiet_vang.should == 2  
    at.minus
    at.late?.should be_true
    at.so_tiet_vang.should == 1
    at.minus
    at.so_tiet_vang.should == 0
    at.attendant?.should be_true
    at.turn(false)
    at.absent?.should be_true
  end
end
