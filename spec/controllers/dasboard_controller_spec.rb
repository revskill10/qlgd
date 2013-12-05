require 'spec_helper'

describe DasboardController do

  describe "GET 'index'" do
    it "returns http success" do
      get dashboard_path
      response.should be_success
    end
  end

end
