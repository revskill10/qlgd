require 'spec_helper'

describe GiangVien do
  it "should have a user" do
  	us = FactoryGirl.create(:giangvien) 
  	gv = FactoryGirl.create(:giang_vien)
  	gv.user = us
  	gv.save
  	#gv.save
  	gv.user.should be_an(User)
  	gv.user.username.should == 'trungth@hpu.edu.vn'
  	us.imageable.should be_a(GiangVien)
  	us.imageable.should == gv
  end

  it "should have many lop mon hoc" do 
    us = FactoryGirl.create(:giangvien) 
    gv = FactoryGirl.create(:giang_vien)
    gv.user = us
    gv.save
    lop = FactoryGirl.create(:lop_mon_hoc)
    calendar = FactoryGirl.create(:calendar, :lop_mon_hoc => lop, :giang_vien => gv)     
    gv.lop_mon_hocs.count.should > 0
    gv.lop_mon_hocs.should include(lop)
  end

  it "should have many lich giang day" do 
    t1 = FactoryGirl.create(:tuan)
    t2 = FactoryGirl.create(:tuan, :tu_ngay => Date.new(2013, 8, 19).change(:offset => Rational(7,24)), :den_ngay => Date.new(2013, 8, 25).change(:offset => Rational(7,24)))
    gv = FactoryGirl.create(:giang_vien)        
    lop = FactoryGirl.create(:lop_mon_hoc)
    calendar = FactoryGirl.create(:calendar, :lop_mon_hoc => lop, :giang_vien => gv)     
  end
end
