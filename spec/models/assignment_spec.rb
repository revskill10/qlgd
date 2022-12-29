require 'spec_helper'

describe Assignment do
  it "should require giang vien, group" do 
    allow_any_instance_of(LopMonHoc).to receive(:tenant).and_return('1')
    Tenant.stub(:hoc_ky).and_return("1")
    Tenant.stub(:nam_hoc).and_return("2013-2014")
  	gv = FactoryGirl.create(:giang_vien)
  	lop = FactoryGirl.create(:lop_mon_hoc, :giang_vien_id => gv.id)

  	ag = lop.assignment_groups.create(name: "Thuc Hanh", weight: 50, giang_vien_id: gv.id)
  	as = ag.assignments.build(name: "BT1", points: 10)
  	as.valid?.should be_false
  	as = ag.assignments.build(name: "BT1", points: 10, giang_vien_id: gv.id)
  	as.valid?.should be_true
  	as.name.should == "BT1"
  end

  
end
