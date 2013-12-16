#encoding: UTF-8
require 'spec_helper'
require 'pg_tools'
include ControllerMacros

feature "Thoi khoa bieu", %q{
	As a teacher, i can visit home page,
	then i can go to calendar page
} do 
	background do
		Capybara.current_driver = :selenium
		Warden.test_mode!    

		#tenant = FactoryGirl.create(:tenant, :name => "public")
		gv = FactoryGirl.create(:giang_vien, :user => nil)
	    us = FactoryGirl.create(:giangvien, :imageable => gv)
	    gv.lop_mon_hocs.create(:ma_lop => "ml1")
	    gv.lop_mon_hocs.create(:ma_lop => "ml2")
	    
	    ApplicationController.any_instance.stub(:current_image).and_return(gv)
	    ApplicationController.any_instance.stub(:load_tenant).and_return(nil)
		login_as(us, :scope => :user) 
	end
	after do 
		Capybara.use_default_driver
		Warden.test_reset! 
	end
	scenario "I can see calendar page" do 
		
	    
		visit '/'
		#visit '/calendar'
		page.should have_content("ml1")
		page.should have_content("ml2")
		#us.imageable.should == gv
		#us.imageable.lop_mon_hocs.count.should == 2
	end
	scenario "I can see lich trinh giang days" do 

	end
end