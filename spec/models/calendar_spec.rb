require 'spec_helper'

describe Calendar do
  it "should have a so_tiet, so_tuan, thu, tiet_bat_dau, tuan_hoc_bat_dau" do
  	lop = FactoryGirl.create(:lop_mon_hoc)
    gv = FactoryGirl.create(:giang_vien)
  	calendar = FactoryGirl.create(:calendar, :lop_mon_hoc => lop, :giang_vien => gv)
  	calendar.so_tiet.should == 3
  end

  it "should require giang vien and lop mon hoc" do 
    lop = FactoryGirl.create(:lop_mon_hoc)
    calendar = FactoryGirl.build(:calendar, :lop_mon_hoc => nil)
    gv = FactoryGirl.create(:giang_vien)
    calendar.valid?.should be_false
    calendar = FactoryGirl.build(:calendar, :lop_mon_hoc => lop, :giang_vien => nil)
    calendar.valid?.should be_false
    calendar = FactoryGirl.build(:calendar, :lop_mon_hoc => lop, :giang_vien => gv)
    calendar.valid?.should be_true
  end
  

  it "should belongs to a GiangVien" do 
    lop = FactoryGirl.create(:lop_mon_hoc)
    gv = FactoryGirl.create(:giang_vien)
    calendar = FactoryGirl.create(:calendar, :lop_mon_hoc => lop, :giang_vien => gv)        
    calendar.giang_vien.should_not be_nil
  end

  it "should have ngay_bat_dau and ngay_ket_thuc" do 
    t1 = FactoryGirl.create(:tuan, :stt => 1, :tu_ngay => Date.new(2013, 8, 12).change(:offset => Rational(7,24)), :den_ngay => Date.new(2013, 8, 18).change(:offset => Rational(7,24)))
    t2 = FactoryGirl.create(:tuan, :stt => 2,  :tu_ngay => Date.new(2013, 8, 19).change(:offset => Rational(7,24)), :den_ngay => Date.new(2013, 8, 25).change(:offset => Rational(7,24)))
    lop = FactoryGirl.create(:lop_mon_hoc)
    gv = FactoryGirl.create(:giang_vien)
    calendar = FactoryGirl.create(:calendar, :lop_mon_hoc => lop, :giang_vien => gv)        
    calendar.ngay_bat_dau.to_date.should == t1.tu_ngay.to_date
    calendar.ngay_ket_thuc.to_date.should == t2.den_ngay.to_date
  end

  it "should generate many lich trinh giang days" do 
    t1 = FactoryGirl.create(:tuan, :stt => 1, :tu_ngay => Date.new(2013, 8, 12).change(:offset => Rational(7,24)), :den_ngay => Date.new(2013, 8, 18).change(:offset => Rational(7,24)))
    t2 = FactoryGirl.create(:tuan, :stt => 2,  :tu_ngay => Date.new(2013, 8, 19).change(:offset => Rational(7,24)), :den_ngay => Date.new(2013, 8, 25).change(:offset => Rational(7,24)))
    t3 = FactoryGirl.create(:tuan, :stt => 3,  :tu_ngay => Date.new(2013, 8, 26).change(:offset => Rational(7,24)), :den_ngay => Date.new(2013, 8, 31).change(:offset => Rational(7,24)))
    lop = FactoryGirl.create(:lop_mon_hoc)
    gv = FactoryGirl.create(:giang_vien)
    calendar = FactoryGirl.create(:calendar, :lop_mon_hoc => lop, :giang_vien => gv)        
    calendar.generate!
    lop.lich_trinh_giang_days.count.should == 2
    lop.lich_trinh_giang_days[0].thoi_gian.localtime.strftime("%Y-%m-%d %H:%M:00").should == "2013-08-12 06:30:00"
  end

end

