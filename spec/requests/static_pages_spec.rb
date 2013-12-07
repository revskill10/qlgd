require 'spec_helper'
include ControllerMacros
describe "StaticPages" do
  describe "About page" do

    it "should have the content 'About Us'" do
      visit '/about'
      expect(page).to have_content('About Us')
    end
  end

  describe "Home page" do
    
    context "As a guest" do  
    	it "should have the content 'Sign in'" do 
    		visit '/'
    		expect(page).to have_content('Sign in')
    	end
    end

    context "As a teacher" do 
      login_giangvien
      it "should have the content 'Sign out'" do 
        visit '/'
        expect(page).to have_content('Sign out')
      end
    end
  end
end
