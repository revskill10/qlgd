#encoding: UTF-8
require 'spec_helper'
include ControllerMacros

feature "Thoi khoa bieu", %q{
	As a teacher, i can visit home page,
	then i can go to calendar page
} do 
	background do
		Capybara.current_driver = :selenium
		Warden.test_mode!    
	end
	after do 
		Capybara.use_default_driver
		Warden.test_reset! 
	end
	scenario "I can see calendar page" do 
		login_giangvien
		visit '/calendar'
		page.should have_content("Thời khóa biểu")
	end
end