#encoding: UTF-8
require 'spec_helper'
require 'pg_tools'
include ControllerMacros

class ActiveRecord::Base
  mattr_accessor :shared_connection
  @@shared_connection = nil

  def self.connection
    @@shared_connection || retrieve_connection
  end
end
ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection
feature "Thoi khoa bieu", %q{
	As a teacher, i can visit home page,
	then i can go to calendar page
} do 
	background do
		Capybara.register_driver :selenium do |app|
		  require 'selenium/webdriver'
		  Selenium::WebDriver::Firefox::Binary.path = 'E:/firefox25/firefox.exe'
		  Capybara::Selenium::Driver.new(app, :browser => :firefox)
		end
		Capybara.current_driver = :selenium
		Warden.test_mode!    

		#tenant = FactoryGirl.create(:tenant, :name => "public")
		
	end
	after do 
		Capybara.use_default_driver
		Warden.test_reset! 
	end

	
	scenario "I can see calendar page" do 
		gv = FactoryGirl.create(:giang_vien)
	    us = FactoryGirl.create(:giangvien)
	    us.imageable = gv
	    us.save!
	    lop1 = FactoryGirl.create(:lop_mon_hoc, :ma_lop => "ml1")
	    lop2 = FactoryGirl.create(:lop_mon_hoc, :ma_lop => "ml2")
	    t1 = FactoryGirl.create(:tuan, :stt => 1, :tu_ngay => Date.new(2013, 8, 12).change(:offset => Rational(7,24)), :den_ngay => Date.new(2013, 8, 18).change(:offset => Rational(7,24)))
	    t2 = FactoryGirl.create(:tuan, :stt => 2,  :tu_ngay => Date.new(2013, 8, 19).change(:offset => Rational(7,24)), :den_ngay => Date.new(2013, 8, 25).change(:offset => Rational(7,24)))
	    t3 = FactoryGirl.create(:tuan, :stt => 3,  :tu_ngay => Date.new(2013, 8, 26).change(:offset => Rational(7,24)), :den_ngay => Date.new(2013, 8, 31).change(:offset => Rational(7,24)))	    
	    calendar1 = lop1.calendars.create(:so_tiet => 3, :so_tuan => 2, :thu => 2, :tiet_bat_dau => 1, :tuan_hoc_bat_dau => 1, :giang_vien_id => gv.id)        
	    calendar2 = lop2.calendars.create(:so_tiet => 3, :so_tuan => 2, :thu => 3, :tiet_bat_dau => 1, :tuan_hoc_bat_dau => 1, :giang_vien_id => gv.id)
	    calendar1.generate!	    
	    calendar2.generate!
	    #ApplicationController.any_instance.stub(:current_image).and_return(gv)
	    ApplicationController.any_instance.stub(:load_tenant).and_return(nil)	    
		login_as(us, :scope => :user) 
	    
		visit '/'
								
		LichTrinhGiangDay.all.count.should == 4
		page.should have_content("Tuần 1")
		page.should have_content("06h30 ngày 12/08/2013")
		page.should have_content("06h30 ngày 13/08/2013")
		page.should have_content("06h30 ngày 19/08/2013")
		page.should have_content("06h30 ngày 20/08/2013")
		#us.imageable.should == gv
		#us.imageable.lop_mon_hocs.count.should == 2
	end
	
end