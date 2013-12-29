class DashboardController < ApplicationController
  
  def index    
  	respond_to do |format|
      if guest?        
        format.html {render "dashboard/index/guest"} 
      elsif teacher?        
        @lichs = current_image.lich_trinh_giang_days
        format.html {render "dashboard/index/teacher"}
      elsif student?        
      	format.html {render "dashboard/index/student"}
      end
  	end
  end

  def show
    @lich = LichTrinhGiangDay.find(params[:id])
    svs = @lich.enrollments
    @enrollments = LichEnrollmentDecorator.decorate_collection(svs)
    respond_to do |format|
      if guest?        
        format.html {render "dashboard/show/guest"} 
      elsif teacher?                    
        format.html {render "dashboard/show/teacher"}
      elsif student?        
        format.html {render "dashboard/show/student"}
      end
    end
  end  

  def lop
    @lop = LopMonHoc.find(params[:id])
    respond_to do |format|
      if guest?        
        format.html {render "dashboard/lop/guest"} 
      elsif teacher?
        @giang_vien = current_user.imageable         
        format.html {render "dashboard/lop/teacher"}
      elsif student?        
        format.html {render "dashboard/lop/student"}
      end
    end
  end
  
end
