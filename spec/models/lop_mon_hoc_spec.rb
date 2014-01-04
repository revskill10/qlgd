#encoding: utf-8
require 'spec_helper'

describe LopMonHoc do
    
  it "should have many teachers" do         
    lop = FactoryGirl.create(:lop_mon_hoc)    
    lop.should respond_to(:giang_viens)
  end

  

  it "should have settings" do 
  	lop = FactoryGirl.create(:lop_mon_hoc, settings: {'language' => 'chinese'})
  	lop.settings['language'].should == "chinese"  	
    lop.settings['language'] = 'vietnamese'
    lop.settings["language"].should == 'vietnamese'
  end
  

  it "should change state" do 
    lop = FactoryGirl.create(:lop_mon_hoc)
    gv = FactoryGirl.create(:giang_vien)
    lop.state.should == "pending"    
    lop.settings.should be_nil        
    lop.start!(gv)
    lop.state.should == "started" # khi da thiet lap thong so
    lop.assignments.count.should == 5
    lop.complete!
    lop.state.should == "completed"
  end

  it "should have many lich_trinh_giang_days" do 
    lop = FactoryGirl.create(:lop_mon_hoc)
    lop.should respond_to(:lich_trinh_giang_days)
  end

  it "should have many giang_viens" do 
    gv = FactoryGirl.create(:giang_vien)
    lop = FactoryGirl.create(:lop_mon_hoc)
    calendar = FactoryGirl.create(:calendar, :lop_mon_hoc => lop, :giang_vien => gv)
    lop.giang_viens.count.should > 0
    lop.giang_viens.should include(gv)
  end

  it "have default assignments settings" do 
    gv = FactoryGirl.create(:giang_vien)
    lop = FactoryGirl.create(:lop_mon_hoc)  
    lop.pending?.should be_true  
    lop.start!(gv)
    lop.started?.should be_true    
    lop.generate_assignments(gv).should eq(nil)
    lop.settings[:generated].should be_true
    lop.assignment_groups.count.should > 0
    lop.assignments.count.should > 0
  end
end
