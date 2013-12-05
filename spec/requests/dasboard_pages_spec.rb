require 'spec_helper'

describe "DashboardPages" do
  include ControllerMacros
  describe "GET /dashboard" do
    it "works! (now write some real specs)" do
      #controller.stub_chain(:current_user,:update_attributes).and_return(nil)   
      get "/dashboard"
      expect(page).to have_content("Sign in")
    end
  end
end
