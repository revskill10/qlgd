require 'spec_helper'

describe LopMonHoc do
    
  it "should have many teachers" do         
    lop = FactoryGirl.create(:lop_mon_hoc)    
    lop.should respond_to(:giang_viens)
  end

  

  it "should have settings" do 
  	lop = FactoryGirl.create(:lop_mon_hoc, settings: {'language' => 'chinese'})
  	lop.language.should == "chinese"  	
    lop.language = 'vietnamese'
    lop.settings["language"].should == 'vietnamese'
  end
  

  it "should change state" do 
    lop = FactoryGirl.create(:lop_mon_hoc)
    lop.state.should == "pending"    
    lop.complete!
    lop.state.should == "completed"
  end

  it "should have many lich_trinh_giang_days" do 
    lop = FactoryGirl.create(:lop_mon_hoc)
    lop.should respond_to(:lich_trinh_giang_days)
  end

end
