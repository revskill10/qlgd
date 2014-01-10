class DashboardController < TenantsController
  
  def index    
  	respond_to do |format|
      format.html {render "index"} 
  	end
  end

  def lich
    @lich = LichTrinhGiangDay.find(params[:id])    
    @giang_vien = @lich.giang_vien   
    svs = @lich.enrollments
    @enrollments = LichEnrollmentDecorator.decorate_collection(svs)
    respond_to do |format|     
      if current_user and Pundit.policy!(current_user, @lich).update?                         
        format.html {render "dashboard/teacher/lich"}            
      else
        format.html {render "dashboard/student/lich"}
      end
    end
  end  

  def lop
    @lop = LopMonHoc.find(params[:id])
    respond_to do |format|
      if current_user and Pundit.policy!(current_user, @lop).update?
        @giang_vien = current_user.giang_vien(@lop)      
        format.html {render "dashboard/teacher/lop"}
      else
        format.html {render "dashboard/student/lop"}
      end
    end
  end
  
  def monitor

    respond_to do |format|
        format.html {render "dashboard/monitor/teacher"}
    end
  end
end
