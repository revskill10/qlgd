require 'spec_helper'

describe LichTrinhGiangDay do  
  before(:each) do 
    d = Date.new(2013, 8, 12)
    (0..46).each do |t|
        FactoryGirl.create(:tuan, :stt => t+1, :tu_ngay => d + t.weeks, :den_ngay => d + t.weeks + 6.day)    
    end   
  end
  it "should require giang_vien, thoi gian va so tiet" do 
  	lop = FactoryGirl.create(:lop_mon_hoc)
    gv = FactoryGirl.create(:giang_vien)
  	lich = lop.lich_trinh_giang_days.normal.build(:so_tiet => 2, :thoi_gian => Time.new(2013, 8, 12, 6, 30))
    #lich.giang_vien = gv
  	
  	lich.valid?.should be_false
  	
  end

  it "should require giang vien" do 
    lop = FactoryGirl.create(:lop_mon_hoc)    
    lich = lop.lich_trinh_giang_days.normal.build(:so_tiet => 2, :thoi_gian => Time.new(2013, 8, 12, 6, 30), :giang_vien_id => nil)
    lich.valid?.should be_false
  end

  it "should belongs to lopmonhoc and giangvien" do 
    lop = FactoryGirl.create(:lop_mon_hoc)
    gv = FactoryGirl.create(:giang_vien)
    lich = lop.lich_trinh_giang_days.normal.build(:so_tiet => 2, :thoi_gian => Time.new(2013, 8, 12, 6, 30))
    lich.giang_vien = gv
    lich.should respond_to(:giang_vien)
    lich.giang_vien.code.should == 'gv1'
    lich.save    
  end

  it "should not be duplicated" do 
  	lop = FactoryGirl.create(:lop_mon_hoc)
    gv = FactoryGirl.create(:giang_vien)
  	lich = lop.lich_trinh_giang_days.normal.build(:so_tiet => 2, :thoi_gian => Time.new(2013, 8, 12, 6, 30))
    lich.giang_vien = gv
    lich.save!
    lich.thoi_gian.localtime.strftime("%Y-%m-%d %H:%M:00").should == "2013-08-12 06:30:00"
    lop.lich_trinh_giang_days.normal.where("thoi_gian = TIMESTAMP ?", lich.thoi_gian.to_time.strftime("%Y-%m-%d %H:%M:00")).first.should_not be_nil
  	lich2 = lop.lich_trinh_giang_days.normal.create(:so_tiet => 2, :thoi_gian => Time.new(2013, 8, 12, 6, 30))
    lich2.giang_vien = gv
    #lich2.save!
  	lich2.errors[:thoi_gian].should  include('duplicates')
    lich3 = lop.lich_trinh_giang_days.normal.where(:so_tiet => 2, :thoi_gian => Time.new(2013, 8, 12, 6, 30)).first_or_create!    
    lich3.should == lich    
  end

  it "should check uniqueness of thoi_gian" do 
    lop = FactoryGirl.create(:lop_mon_hoc)
    gv = FactoryGirl.create(:giang_vien)
    lich = lop.lich_trinh_giang_days.normal.build(:so_tiet => 2, :thoi_gian => Time.new(2013, 8, 12, 6, 30), :giang_vien_id => gv.id)
    lich.save!
    t = LichTrinhGiangDay.where(thoi_gian: lich.thoi_gian).first
    t.should_not be_nil
    t.so_tiet.should == 2
  end

  it "has tuan do" do     
    lop = FactoryGirl.create(:lop_mon_hoc)
    gv = FactoryGirl.create(:giang_vien)
    lich = lop.lich_trinh_giang_days.bosung.create(:so_tiet => 2, :thoi_gian => Time.new(2013, 8, 12, 6, 30), :giang_vien_id => gv.id)    
    ["nghile", "normal", "bosung", "nghiday"].include?(lich.state).should be_true
    lich.waiting?.should be_true
    lich.can_accept?.should be_true
    lich.accept!    
    lich.tuan.should == 1
  end

  it "has states" do    
    lop = FactoryGirl.create(:lop_mon_hoc)
    gv = FactoryGirl.create(:giang_vien)
    lich = lop.lich_trinh_giang_days.bosung.create(:so_tiet => 2, :thoi_gian => Time.new(2013, 8, 12, 6, 30), :giang_vien_id  => gv.id)    
    ["nghile", "normal", "bosung", "nghiday"].include?(lich.state).should be_true
    lich.state.should eq("bosung")
    lich.waiting?.should be_true
    lich.can_accept?.should be_true
    lich.accept!
    lich.accepted?.should be_true
    lich.state.should == "bosung"
  end

  it "has many attendances" do 
    lop = FactoryGirl.create(:lop_mon_hoc)
    gv = FactoryGirl.create(:giang_vien)
    lich = lop.lich_trinh_giang_days.normal.build(:so_tiet => 2, :thoi_gian => Time.new(2013, 8, 12, 6, 30), :giang_vien_id  => gv.id)
    lich.attendances.count.should == 0
  end  

  it "can be dang ky bo sung" do     
    lop = FactoryGirl.create(:lop_mon_hoc)
    gv = FactoryGirl.create(:giang_vien)
    lich = lop.lich_trinh_giang_days.bosung.create(:so_tiet => 2, :thoi_gian => Time.new(2013, 8, 12, 6, 35), :giang_vien_id => gv.id)
    ["nghile", "normal", "bosung", "nghiday"].include?(lich.state).should be_true
    lich.state.should eq("bosung")
    lich.can_accept?.should be_true
    lich.waiting?.should be_true
    lich.accept!
    lich.state.should eq("bosung")
    lich.thoi_gian.to_time.should eq(Time.new(2013, 8, 12, 6, 35))
    lop.lich_trinh_giang_days.where(thoi_gian: Time.new(2013, 8, 12, 6, 35)).first.should eq(lich)
  end

  it "should validate tuan > 0 and giang_vien_id > 0" do 
    lop = FactoryGirl.create(:lop_mon_hoc)
    gv = FactoryGirl.create(:giang_vien)
    lich = lop.lich_trinh_giang_days.normal.build(:so_tiet => 2, :thoi_gian => Time.new(2013, 7, 12, 6, 35), :giang_vien_id => gv.id, :state => :bosung)
    lich.valid?.should be_false
    lich = lop.lich_trinh_giang_days.normal.build(:so_tiet => 2, :thoi_gian => Time.new(2013, 8, 12, 6, 35), :giang_vien_id => 0, :state => :bosung)    
    lich.valid?.should be_false
  end
end
