require 'spec_helper'

describe LichTrinhGiangDay do  
  it "should require giang_vien, thoi gian va so tiet" do 
  	lop = FactoryGirl.create(:lop_mon_hoc)
    gv = FactoryGirl.create(:giang_vien)
  	lich = lop.lich_trinh_giang_days.build(:so_tiet => 2, :thoi_gian => DateTime.new(2013, 8, 12, 6, 30))
    #lich.giang_vien = gv
  	lich.tiet_bat_dau = lich.get_tiet_bat_dau
    lich.tiet_bat_dau.should == 1
  	lich.valid?.should be_false
  	
  end

  it "should require giang vien" do 
    lop = FactoryGirl.create(:lop_mon_hoc)    
    lich = lop.lich_trinh_giang_days.build(:so_tiet => 2, :thoi_gian => DateTime.new(2013, 8, 12, 6, 30), :giang_vien_id => nil)
    lich.valid?.should be_false
  end

  it "should belongs to lopmonhoc and giangvien" do 
    lop = FactoryGirl.create(:lop_mon_hoc)
    gv = FactoryGirl.create(:giang_vien)
    lich = lop.lich_trinh_giang_days.build(:so_tiet => 2, :thoi_gian => DateTime.new(2013, 8, 12, 6, 30))
    lich.giang_vien = gv
    lich.should respond_to(:giang_vien)
    lich.giang_vien.code.should == 'gv1'
    lich.save    
  end

  it "should not be duplicated" do 
  	lop = FactoryGirl.create(:lop_mon_hoc)
    gv = FactoryGirl.create(:giang_vien)
  	lich = lop.lich_trinh_giang_days.build(:so_tiet => 2, :thoi_gian => DateTime.new(2013, 8, 12, 6, 30))
    lich.giang_vien = gv
    lich.save!
    lich.thoi_gian.strftime("%Y-%m-%d %H:%M:00").should == "2013-08-12 06:30:00"
    lop.lich_trinh_giang_days.where("thoi_gian = TIMESTAMP ?", lich.thoi_gian.strftime("%Y-%m-%d %H:%M:00")).first.should_not be_nil
  	lich2 = lop.lich_trinh_giang_days.create(:so_tiet => 2, :thoi_gian => DateTime.new(2013, 8, 12, 6, 30))
    lich2.giang_vien = gv
    #lich2.save!
  	lich2.errors[:name].should  include('duplicates thoi_gian')
    lich3 = lop.lich_trinh_giang_days.where(:so_tiet => 2, :thoi_gian => DateTime.new(2013, 8, 12, 6, 30)).first_or_create!    
    lich3.should == lich    
  end

  it "should check uniqueness of thoi_gian" do 
    lop = FactoryGirl.create(:lop_mon_hoc)
    gv = FactoryGirl.create(:giang_vien)
    lich = lop.lich_trinh_giang_days.build(:so_tiet => 2, :thoi_gian => DateTime.new(2013, 8, 12, 6, 30), :giang_vien_id => gv.id)
    lich.save!
    t = LichTrinhGiangDay.where(thoi_gian: lich.thoi_gian).first
    t.should_not be_nil
    t.so_tiet.should == 2
  end

  it "has tuan do" do 
    t1 = FactoryGirl.create(:tuan)
    t2 = FactoryGirl.create(:tuan, :tu_ngay => Date.new(2013, 8, 19).change(:offset => Rational(7,24)), :den_ngay => Date.new(2013, 8, 25).change(:offset => Rational(7,24)))
    lop = FactoryGirl.create(:lop_mon_hoc)
    gv = FactoryGirl.create(:giang_vien)
    lich = lop.lich_trinh_giang_days.build(:so_tiet => 2, :thoi_gian => DateTime.new(2013, 8, 12, 6, 30))
    lich.giang_vien = gv
    lich.load_tuan.should == 1
    lich.state.should == "pending"
  end

  it "has states" do 
    lop = FactoryGirl.create(:lop_mon_hoc)
    gv = FactoryGirl.create(:giang_vien)
    lich = lop.lich_trinh_giang_days.build(:so_tiet => 2, :thoi_gian => DateTime.new(2013, 8, 12, 6, 30), :giang_vien_id  => gv.id)
    lich.status.should == "waiting"
    lich.state.should == "pending"
    lich.accept!
    lich.status.should == "accepted"
    lich.complete!
    lich.state.should == "completed"
  end
end
