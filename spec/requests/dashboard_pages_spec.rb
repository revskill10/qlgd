require 'spec_helper'
include ControllerMacros

describe "DashboardPages" do  

  context "As a guest" do     
    it "works as guest" do      
      visit "/dashboard"
      expect(page).to have_content("Guest")
    end
  end

  context "As a teacher" do       	
  	login_giangvien
    it "works as teacher" do     	
    	visit "/dashboard"
    	expect(page).to have_content("GiangVien")
    end
  end


end
