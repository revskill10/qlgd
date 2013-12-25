#encoding: UTF-8
require 'spec_helper'
require 'pg_tools'
include ControllerMacros


describe EnrollmentsController do 
	
#	 it "get info lich" do 
#		lich = LichTrinhGiangDay.find(1)
#		get :index, lich_id: 1
#		assigns(:lich).should eq(lich)
#		sign_out @us
	#end 
	prepare
	it "update enrollment information" do 
		
		lich = LichTrinhGiangDay.find(1)
		post :update, :stat => 'vang', :lich_id => 1, :enrollment => {:sinh_vien_id => 1, :id => 1, :phep => false}, :format => :json
		assigns(:lich).should eq(lich)		
		assigns(:attendance).so_tiet_vang.should eq(3)
		assigns(:attendance).state.should eq("absent")
		assigns(:attendance).decorate.phep_status.should eq("Không phép")
=begin		
		response.body.should == {
				"lich"=>{"id"=>1,"phong"=>nil,"noi_dung"=>nil,"state"=>"started","status"=>"waiting","sv_co_mat"=>1,"sv_vang_mat"=>0},
			"enrollments"=>[
				{"id"=>1,"name"=>"ho1 dem1 ten1","code"=>"sv1","status"=>"Vắng","so_tiet_vang"=>3,"phep"=>nil,"max"=>3,"phep_status"=>"Không phép","note"=>nil}]
		}.to_json
=end

		
	end
=begin
	it "get info lich" do 		
		
		lich = LichTrinhGiangDay.find(1)
		get :index, lich_id: 1
		assigns(:lich).should eq(lich)
		
	end 
=end	
end