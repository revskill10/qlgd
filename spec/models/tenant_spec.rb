require 'spec_helper'

describe Tenant do
  it "should have a hocky, namhoc, ngay_bat_dau, ngay_ket_thuc" do
  	tenant = FactoryGirl.create(:tenant)   	
  	tenant.should be_valid
  end

  it "should have private schema" do 
  	t1 = FactoryGirl.create(:tenant)
  	t2 = FactoryGirl.create(:tenant, name: "t2", hoc_ky: "2", nam_hoc: "2013-2014", ngay_bat_dau: DateTime.new(2013, 12, 2), ngay_ket_thuc: DateTime.new(2013, 3, 1))
    PgTools.set_search_path t1.name
    us = FactoryGirl.create(:user)
    us.username.should == "revskill09@gmail.com"    
  end
end
