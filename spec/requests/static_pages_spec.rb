require 'spec_helper'

describe "StaticPages" do
  describe "About page" do

    it "should have the content 'About Us'" do
      visit '/about'
      expect(page).to have_content('About Us')
    end
  end
end
