#encoding: utf-8
class Teacher::AttendancesController < TenantsController
  
  def index    
    
   	@lich = LichTrinhGiangDay.find(params[:lich_id])   
    #authorize @lich, :update?   
    #authorize @lich, :update?
    enrollments = @lich.lop_mon_hoc.enrollments    
    results = enrollments.map {|en| LichEnrollmentDecorator.new(en,@lich) }.map {|e| LichEnrollmentSerializer.new(e)}
    render json: {info: {lop: LopMonHocSerializer.new(@lich.lop_mon_hoc),  lich: LichTrinhGiangDaySerializer.new(@lich.decorate)}, enrollments: results}.to_json
    
  end
  def settinglop
    
      @lich = LichTrinhGiangDay.find(params[:lich_id])
      render json: {:error => 'Lịch giảng dạy không tìm thấy'} unless @lich
      @lop = @lich.lop_mon_hoc
      authorize @lop, :update?
      @lop.settings[:so_tiet_ly_thuyet] = params[:lop][:so_tiet_ly_thuyet].to_i
      @lop.settings[:so_tiet_thuc_hanh] = params[:lop][:so_tiet_thuc_hanh].to_i
      @lop.save!
      enrollments = @lich.lop_mon_hoc.enrollments    
      results = enrollments.map {|en| LichEnrollmentDecorator.new(en,@lich) }.map {|e| EnrollmentSerializer.new(e)}
      render json: {info: {lop: LopMonHocSerializer.new(@lich.lop_mon_hoc),  lich: LichTrinhGiangDaySerializer.new(@lich.decorate)}, enrollments: results}.to_json
    
  end
  def update  	
    
    	@lich = LichTrinhGiangDay.find(params[:lich_id])      
      render json: {:error => 'Lịch giảng dạy không tìm thấy'} unless @lich
      authorize @lich, :update?
      @sv= SinhVien.find(params[:enrollment][:sinh_vien_id])
      render json: {:error => 'Sinh viên không tìm thấy'} unless @sv
    	@attendance = @lich.attendances.where(sinh_vien_id: @sv.id).first_or_create!
      render json: {:error => 'Điểm danh không tìm thấy'} unless @attendance
      if params[:stat] == 'vang'
    	  @attendance.turn(params[:enrollment][:phep])    
      elsif params[:stat] == 'plus'
        @attendance.plus
      elsif params[:stat] == 'minus'
        @attendance.minus
      elsif params[:stat] == 'phep'
        @attendance.turn_phep
      elsif params[:stat] == 'idle'
        @attendance.turn_idle
      elsif params[:stat] == 'note'
        @attendance.set_note(params[:enrollment][:note])
      end
      @attendance.save!  
      #attendance.mark_absent(false)
      #lich = LichTrinhGiangDay.find(params[:lich_id])
      enrollments = @lich.lop_mon_hoc.enrollments    
      results = enrollments.map {|en| LichEnrollmentDecorator.new(en,@lich) }.map {|e| LichEnrollmentSerializer.new(e)}
      render json: {info: {lop: LopMonHocSerializer.new(@lich.lop_mon_hoc),  lich: LichTrinhGiangDaySerializer.new(@lich.decorate)}, enrollments: results}.to_json
    
  end 
  def noidung
    
      @lich = LichTrinhGiangDay.find(params[:id])
      render json: {:error => 'Lịch giảng dạy không tìm thấy'} unless @lich
      authorize @lich, :update?
      @lich.noi_dung = params[:content]
      @lich.save!            
      render json: {lich: LichTrinhGiangDaySerializer.new(@lich.decorate)}.to_json
    
  end 
  def getnoidung
    @lich = LichTrinhGiangDay.find(params[:lich_id])
    render json: {:error => 'Lịch giảng dạy không tìm thấy'} unless @lich
    #authorize @lich, :update?
    render json: {lich: LichTrinhGiangDaySerializer.new(@lich.decorate)}.to_json
  end
end  