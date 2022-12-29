require 'spec_helper'

describe UserGroup do
  it "belongs to user and group" do 
  	group = Group.create(name: "bankiemdinh")
  	u = FactoryGirl.create(:user)
  	ug = UserGroup.create(group_id: group.id, user_id: u.id)
  	ug.group.name.should == "bankiemdinh"
  	u.groups.pluck(:name).should include("bankiemdinh")
  end
end
