require 'spec_helper'

describe LopMonHoc do
    
  it "should belongs to a teacher" do         
    lop = FactoryGirl.create(:lop_mon_hoc, :giang_vien => FactoryGirl.create(:giang_vien))    
    lop.giang_vien.should be_a(GiangVien)
  end

  

  it "should have settings with hstore" do 
  	lop = FactoryGirl.create(:lop_mon_hoc, settings: {'language' => 'chinese'})
  	lop.language.should == "chinese"  	
    lop.language = 'vietnamese'
    lop.settings["language"].should == 'vietnamese'
  end
  

  it "should change state" do 
    lop = FactoryGirl.create(:lop_mon_hoc)
    lop.state.should == "pending"
    lop.start!
    lop.state.should == "started"
    lop.complete!
    lop.state.should == "completed"
  end

  
end
