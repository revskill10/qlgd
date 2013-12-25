class EnrollmentsController < ApplicationController
  
  def index       	
   	lich = LichTrinhGiangDay.find(params[:lich_id])
    enrollments = lich.lop_mon_hoc.enrollments    
    results = enrollments.map {|en| EnrollmentDecorator.new(en,lich) }.map {|e| EnrollmentSerializer.new(e)}
    render json: {lich: LichTrinhGiangDaySerializer.new(lich.decorate), enrollments: results}.to_json
  end
  def update  	
  	lich = LichTrinhGiangDay.find(params[:lich_id])
  	attendance = lich.attendances.where(sinh_vien_id: params[:enrollment][:id]).first_or_create!
    if params[:stat] == 'vang'
  	  attendance.turn(params[:enrollment][:phep])    
    elsif params[:stat] == 'plus'
      attendance.plus
    elsif params[:stat] == 'minus'
      attendance.minus
    end
    #attendance.save!  
    #attendance.mark_absent(false)
    #lich = LichTrinhGiangDay.find(params[:lich_id])
    enrollments = lich.lop_mon_hoc.enrollments    
    results = enrollments.map {|en| EnrollmentDecorator.new(en,lich) }.map {|e| EnrollmentSerializer.new(e)}
    render json: {lich: LichTrinhGiangDaySerializer.new(lich.decorate), enrollments: results}.to_json
  end
  def test
    
    attendance = Attendance.find(1)    
    attendance.turn(false)
    attendance.save!
    render json: {res: attendance.so_tiet_vang, state: attendance.state, lich: attendance.lich_trinh_giang_day.so_tiet_moi}
  end
end  