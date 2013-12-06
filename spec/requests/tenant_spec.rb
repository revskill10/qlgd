#encoding: utf-8
require 'spec_helper'

describe "Tenants page" do

  subject { page }
  describe "tenants page" do
    before { visit '/tenants' }

    it { should have_content('Học kỳ 1') }    
  end

  
end
