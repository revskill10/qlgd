require 'spec_helper'

describe Submission do
  it "require assignment_id, sinh_vien_id, giang_vien_id" do 
  	sv = FactoryGirl.create(:sinh_vien)
  	gv = FactoryGirl.create(:giang_vien)
  	lop = FactoryGirl.create(:lop_mon_hoc, :giang_vien_id => gv.id)
  	ag = lop.assignment_groups.create(name: "Thuc Hanh", weight: 50, giang_vien_id: gv.id)
  	as = ag.assignments.create(name: "BT1", points: 10)  	
  	
  	as.name.should == "BT1"
  	sub = as.submissions.where(sinh_vien_id: sv.id, giang_vien_id: gv.id).first_or_create!
  	sub.giang_vien.id.should == gv.id
  	#sub2 = as.submissions.create(sinh_vien_id: sv.id, giang_vien_id: gv.id)
  	#sub2.giang_vien.id.should == gv.id
  end
end
