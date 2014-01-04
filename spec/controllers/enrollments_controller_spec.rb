#encoding: UTF-8
require 'spec_helper'
include ControllerMacros


describe AttendancesController do 
	
	describe "As a teacher" do 
		
		it "can update enrollment information" do 			
			sv = FactoryGirl.create(:sinh_vien)
	      gv = FactoryGirl.create(:giang_vien)
	      us = FactoryGirl.create(:giangvien)
	      us.imageable = gv
	      us.save!
	      lop1 = FactoryGirl.create(:lop_mon_hoc, :ma_lop => "ml1", :settings => {})
	      en = FactoryGirl.create(:enrollment, :sinh_vien => sv, :lop_mon_hoc => lop1)
	      lop2 = FactoryGirl.create(:lop_mon_hoc, :ma_lop => "ml2", :settings => {})
	      t1 = FactoryGirl.create(:tuan, :stt => 1, :tu_ngay => Date.new(2013, 8, 12).change(:offset => Rational(7,24)), :den_ngay => Date.new(2013, 8, 18).change(:offset => Rational(7,24)))
	      t2 = FactoryGirl.create(:tuan, :stt => 2,  :tu_ngay => Date.new(2013, 8, 19).change(:offset => Rational(7,24)), :den_ngay => Date.new(2013, 8, 25).change(:offset => Rational(7,24)))
	      t3 = FactoryGirl.create(:tuan, :stt => 3,  :tu_ngay => Date.new(2013, 8, 26).change(:offset => Rational(7,24)), :den_ngay => Date.new(2013, 8, 31).change(:offset => Rational(7,24)))     
	      calendar1 = lop1.calendars.create(:so_tiet => 3, :so_tuan => 2, :thu => 2, :tiet_bat_dau => 1, :tuan_hoc_bat_dau => 1, :giang_vien_id => gv.id)        
	      calendar2 = lop2.calendars.create(:so_tiet => 3, :so_tuan => 2, :thu => 3, :tiet_bat_dau => 1, :tuan_hoc_bat_dau => 1, :giang_vien_id => gv.id)
	      lop1.reload.generate_calendars
	      lop2.reload.generate_calendars
	      #ApplicationController.any_instance.stub(:current_image).and_return(gv)
	      ApplicationController.any_instance.stub(:load_tenant).and_return(nil)     
	      sign_in :user, us  
	      lop1.start!(gv)
	      lop2.start!(gv)
			lich = LichTrinhGiangDay.find(1)
			lich.so_tiet.should == 3
			post :update, :stat => 'vang', :lich_id => 1, :enrollment => {:sinh_vien_id => 1, :id => 1, :phep => false}, :format => :json
			
			assigns(:attendance).so_tiet_vang.should eq(3)
			assigns(:attendance).state.should eq("absent")
			assigns(:attendance).decorate.phep_status.should eq("Không phép")	

		end
	end	
end