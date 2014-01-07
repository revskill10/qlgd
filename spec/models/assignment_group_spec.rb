require 'spec_helper'

describe AssignmentGroup do
  
  it "should require name, weight, giang_vien_id" do
    gv = FactoryGirl.create(:giang_vien)
    lop = FactoryGirl.create(:lop_mon_hoc, :giang_vien_id => gv.id) 
  	ag = lop.assignment_groups.create(name: "Thuc Hanh", weight: 50, giang_vien_id: gv.id)
  	ag.valid?.should be_true
  	ag.name.should == "Thuc Hanh"
  	ag.destroy if ag.can_destroy?
  end

end
