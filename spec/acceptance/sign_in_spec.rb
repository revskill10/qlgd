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


	
end