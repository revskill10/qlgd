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
    @enrollments = EnrollmentDecorator.decorate_collection(svs)
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

  def diemdanh
    @sv = SinhVien.find(params[:sv])
    respond_to do |format|
      if teacher?                    
        format.js {render "dashboard/attendances/teacher"}      
      end
    end
  end

end
