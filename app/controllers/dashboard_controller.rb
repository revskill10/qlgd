class DashboardController < TenantsController
  
  def index    
  	respond_to do |format|
      format.html {render "dashboard/index"} 
  	end
  end

  def show
    @lich = LichTrinhGiangDay.find(params[:id])
    authorize @lich, :update?
    svs = @lich.enrollments
    @enrollments = LichEnrollmentDecorator.decorate_collection(svs)
    respond_to do |format|      
      @giang_vien = @lich.giang_vien                 
      format.html {render "dashboard/lich/update"}            
    end
  end  

  def lop
    @lop = LopMonHoc.find(params[:id])
    respond_to do |format|
      @giang_vien = current_user.imageable
      authorize @lop, :update?
      format.html {render "dashboard/lop/update"}
    end
  end
  
  def monitor

    respond_to do |format|
        format.html {render "dashboard/monitor/teacher"}
    end
  end
end
