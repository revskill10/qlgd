module ControllerMacros
  include Warden::Test::Helpers
  
  def login_admin
    before(:each) do      
      Warden.test_mode!
      user = FactoryGirl.create(:admin) # Using factory girl as an example
      login_as(user, :scope => :user)
    end
    after(:each) do 
      Warden.test_reset! 
    end
  end

  def login_user
    before(:each) do   
      Warden.test_mode!   
      user = FactoryGirl.create(:user)
      user.confirm! # or set a confirmed_at inside the factory. Only necessary if you are using the confirmable module
      login_as(user, :scope => :user)
    end
    after(:each) do 
      Warden.test_reset! 
    end
  end

  def login_sinhvien
    before(:each) do     
      Warden.test_mode!  
      sv = FactoryGirl.create(:sinh_vien)
      user = FactoryGirl.create(:sinhvien)
      sv.user = user
      login_as(user, :scope => :user)
    end
    after(:each) do 
      Warden.test_reset! 
    end
  end

  def login_giangvien
    before(:each) do  
      Warden.test_mode!     
      gv = FactoryGirl.create(:giang_vien)
      user = FactoryGirl.create(:giangvien)
      gv.user = user
      login_as(user, :scope => :user)
    end
    after(:each) do 
      Warden.test_reset! 
    end
  end
end

RSpec.configure do |config|
  config.include Devise::TestHelpers, :type => :controller
  config.include ControllerMacros, :type => :controller
end