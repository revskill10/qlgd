#encoding: UTF-8
require 'spec_helper'
include ControllerMacros

feature "Sign in", %q{
	As a guest, i can visit home page,
	then i can be redirected to CAS url,
	then i can login with my account
} do 
	background do
		Capybara.current_driver = :selenium
		Warden.test_mode!    
	end
	after do 
		Capybara.use_default_driver
		Warden.test_reset! 
	end
	scenario "I can be redirect to cas url" do 		
		visit '/'
		click_link 'Sign in'
		current_url.should include('localhost:3001')
		page.should have_content("Địa chỉ Email")
	end
	
	scenario "Sign in as Teacher" do 
		user = FactoryGirl.create(:giangvien)      	 
        gv = FactoryGirl.create(:giang_vien, :user => user)      
        login_as(user, :scope => :user)
		visit '/'
		page.should have_content('Teacher')
		click_link 'Sign out'
		page.should have_content('Địa chỉ Email')
	end
	
	scenario "Invalid sign in" do 		
		visit '/'
		click_on 'Sign in'
		fill_in 'username', :with => 'abc@abc'
		fill_in 'password', :with => '1234'
		click_on 'Đăng nhập'
		page.should have_content('Địa chỉ Email')
	end

	scenario "Sign in as a Student" do 
		user = FactoryGirl.create(:sinhvien)      	 
        sv = FactoryGirl.create(:sinh_vien, :user => user)      
        login_as(user, :scope => :user)
		visit '/'
		page.should have_content('Student')
		click_link 'Sign out'
		page.should have_content('Địa chỉ Email')
	end
end