class Student::AttendancesController < TenantsController
  
  def index    
    
   	@lich = LichTrinhGiangDay.find(params[:lich_id])   
    #authorize @lich, :update?   
    #authorize @lich, :update?
    enrollments = @lich.lop_mon_hoc.enrollments    
    results = enrollments.map {|en| LichEnrollmentDecorator.new(en,@lich) }.map {|e| LichEnrollmentSerializer.new(e)}
    render json: {info: {lop: LopMonHocSerializer.new(@lich.lop_mon_hoc),  lich: LichTrinhGiangDaySerializer.new(@lich.decorate)}, enrollments: results}.to_json
    
  end
end