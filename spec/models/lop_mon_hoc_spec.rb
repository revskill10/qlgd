#encoding: utf-8
require 'spec_helper'

describe LopMonHoc do
    
  it "should be created and removed" do    
    Tenant.create(name: 'hk1', hoc_ky: '1', nam_hoc:'2013-2014')     
    lop = LopMonHoc.create(ma_lop: 'ml1', ma_mon_hoc: 'mm1', ten_mon_hoc: 'tm1', settings: {})
    lop.valid?.should be_true    
    lop.pending?.should be_true
    lop.start!
    lop.started?.should be_true
    lop.assignments.count.should == 5
    lop.remove!
    lop.removed?.should be_true
  end

  
  


  
end
