require 'spec_helper'

describe Enrollment do
  it "should require sinh vien and course" do 
  	en = FactoryGirl.build(:enrollment, :sinh_vien => nil)
  	en.valid?.should be_false
  end
  it "should belongs to course and student" do 
  	sv = FactoryGirl.create(:sinh_vien)
  	lop = FactoryGirl.create(:lop_mon_hoc)
  	en = FactoryGirl.build(:enrollment, :sinh_vien => sv, :lop_mon_hoc => lop)
  	en.sinh_vien.ho.should == "ho1"
  end
  it "has many lich trinh giang day" do 
  	sv = FactoryGirl.create(:sinh_vien)
  	lop = FactoryGirl.create(:lop_mon_hoc)
  	en = FactoryGirl.build(:enrollment, :sinh_vien => sv, :lop_mon_hoc => lop)
  	en.should respond_to(:lich_trinh_giang_days)
  end
  it "has attendance information" do
  	t1 = FactoryGirl.create(:tuan, :stt => 1, :tu_ngay => Date.new(2013, 8, 12).change(:offset => Rational(7,24)), :den_ngay => Date.new(2013, 8, 18).change(:offset => Rational(7,24)))
    t2 = FactoryGirl.create(:tuan, :stt => 2,  :tu_ngay => Date.new(2013, 8, 19).change(:offset => Rational(7,24)), :den_ngay => Date.new(2013, 8, 25).change(:offset => Rational(7,24)))
    t3 = FactoryGirl.create(:tuan, :stt => 3,  :tu_ngay => Date.new(2013, 8, 26).change(:offset => Rational(7,24)), :den_ngay => Date.new(2013, 8, 31).change(:offset => Rational(7,24)))
    lop = FactoryGirl.create(:lop_mon_hoc)
    gv = FactoryGirl.create(:giang_vien)
    calendar = FactoryGirl.create(:calendar, :lop_mon_hoc => lop, :giang_vien => gv)        
    calendar.generate! 
  	sv = FactoryGirl.create(:sinh_vien)  	
  	en = FactoryGirl.create(:enrollment, :sinh_vien => sv, :lop_mon_hoc => lop)
  	lich = lop.lich_trinh_giang_days.order('thoi_gian').first
  	lich.so_tiet_moi.should == 3
  	at = lich.attendances.where(sinh_vien_id: sv.id).first_or_create!
  	at.turn(false)    
    at.save!
    at.so_tiet_vang.should == 3
    en = lop.enrollments.where(sinh_vien_id: sv.id).first    
  	en.lop_mon_hoc_id.should == lop.id
    en.sinh_vien_id.should == sv.id
    en.attendances.count.should == 1
    en.attendances.first.id.should == at.id
    en.tong_vang.should == 3
  end

  it "have diem qua trinh" do 
    gv = FactoryGirl.create(:giang_vien)
    sv = FactoryGirl.create(:sinh_vien)
    lop = FactoryGirl.create(:lop_mon_hoc)  
    lop.pending?.should be_true  
    lop.start!
    lop.started?.should be_true    
    lop.generate_assignments(gv)
    en = lop.enrollments.where(:sinh_vien_id => sv.id).first_or_create
    subs = lop.assignments
    subs.each do |s|
      g = s.submissions.where(sinh_vien_id: sv.id, giang_vien_id: gv.id).first_or_create
      g.grade = 7
      g.save!
    end
    en.diem_qua_trinh.should == 7
  end
end
