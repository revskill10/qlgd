require 'spec_helper'

describe User do
  it "should have a code" do 
  	user = FactoryGirl.build(:user)
  	user.username.should be("revskill09@gmail.com")
  end
end
