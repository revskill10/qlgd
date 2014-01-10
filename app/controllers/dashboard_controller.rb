class DashboardController < TenantsController
  
  def index    
  	respond_to do |format|
      format.html {render "dashboard/index"} 
  	end
  end

  def show
    @lich = LichTrinhGiangDay.find(params[:id])    
    svs = @lich.enrollments
    @enrollments = LichEnrollmentDecorator.decorate_collection(svs)
    respond_to do |format|     
      if current_user and Pundit.policy!(current_user, @lich).update?     
        @giang_vien = @lich.giang_vien                 
        format.html {render "dashboard/lich/update"}            
      else
        format.html {render "dashboard/lich/show"}
      end
    end
  end  

  def lop
    @lop = LopMonHoc.find(params[:id])
    respond_to do |format|
      if current_user and Pundit.policy!(current_user, @lop).update?
        @giang_vien = current_user.giang_vien(@lop)      
        format.html {render "dashboard/lop/update"}
      else
        format.html {render "dashboard/lop/show"}
      end
    end
  end
  
  def monitor

    respond_to do |format|
        format.html {render "dashboard/monitor/teacher"}
    end
  end
end
