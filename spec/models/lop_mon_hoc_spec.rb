require 'spec_helper'

describe LopMonHoc do

  it "should require a ma_lop, ma_giang_vien, ma_mon_hoc" do
    FactoryGirl.build(:lop_mon_hoc, :ma_lop => "").should_not be_valid
    FactoryGirl.build(:lop_mon_hoc, :ma_giang_vien => "").should_not be_valid
    FactoryGirl.build(:lop_mon_hoc, :ma_mon_hoc => "").should_not be_valid
  end
  

  it "should be created with ma_lop, ma_giang_vien, ma_mon_hoc" do 
  	lop = FactoryGirl.create(:lop_mon_hoc)
  	lop.should be_valid
  	lop.ma_lop.should == "ml1"
  end

  it "should have settings with hstore" do 
  	lop = FactoryGirl.create(:lop_mon_hoc, settings: {'language' => 'chinese'})
  	lop.language.should == "chinese"  	
  end

  it "should be updated with hstore settings" do 
  	lop = FactoryGirl.create(:lop_mon_hoc)
  	lop.language = 'chinese'
  	lop.settings["language"].should == 'chinese'
  end


end
