class DashboardController < ApplicationController
  
  def index    
  	respond_to do |format|
      if guest?        
        format.html {render "dashboard/index/guest"} 
      elsif teacher?        
        @giang_vien = current_user.imageable
        format.html {render "dashboard/index/teacher"}
      elsif student?        
      	format.html {render "dashboard/index/student"}
      end
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
      if guest?        
        format.html {render "dashboard/lop/guest"} 
      elsif teacher?
        @giang_vien = current_user.imageable
        authorize @lop, :update?
        format.html {render "dashboard/lop/teacher"}
      elsif student?        
        format.html {render "dashboard/lop/student"}
      end
    end
  end
  
  def monitor

    respond_to do |format|
      if guest?

      elsif teacher?

        format.html {render "dashboard/monitor/teacher"}
      elsif student?

      end
    end
  end
end
