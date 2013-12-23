class EnrollmentsController < ApplicationController
  
  def index       	
   	lich = LichTrinhGiangDay.find(params[:lich_id])
    enrollments = lich.lop_mon_hoc.enrollments
    #attendances = lich.attendances
    results = enrollments.map {|en| EnrollmentDecorator.new(en,lich) }.map {|e| EnrollmentSerializer.new(e)}

    render json: results.to_json
  end
end  