#encoding: UTF-8
require 'spec_helper'
include ControllerMacros


describe EnrollmentsController do 
	
	describe "update" do 
		prepare
		it "update enrollment information" do 			
			lich = LichTrinhGiangDay.find(1)
			post :update, :stat => 'vang', :lich_id => 1, :enrollment => {:sinh_vien_id => 1, :id => 1, :phep => false}, :format => :json
			assigns(:lich).should eq(lich)		
			assigns(:attendance).so_tiet_vang.should eq(3)
			assigns(:attendance).state.should eq("absent")
			assigns(:attendance).decorate.phep_status.should eq("Không phép")
		
			response.body.should == {
				:info => {
					:lop => {:id => 1, :ma_lop => "ml1", :ma_mon_hoc => "mm1", :ten_mon_hoc => "tm1", :si_so => 1, :so_tiet_ly_thuyet => nil, :so_tiet_thuc_hanh => nil, :updated => false} ,
					"lich"=>{"id"=>1,"phong"=>nil,"noi_dung"=>nil,:updated => true,"status"=>"waiting","sv_co_mat"=>0,"sv_vang_mat"=>1} },
				:enrollments => [
					{"id"=>1,:sinh_vien_id => 1,"name"=>"ho1 dem1 ten1","code"=>"sv1","status"=>"Vắng","so_tiet_vang"=>3,"phep"=>false,"max"=>3,"phep_status"=>"Không phép","note"=>nil, :tong_vang => 3}]
			}.to_json				
		end
	end	
end