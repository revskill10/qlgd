require 'spec_helper'

describe "static_pages/about.html.slim" do
  it "should be ok" do 
  	visit '/about'
  	expect(page).to have_content("About")
  end
end
