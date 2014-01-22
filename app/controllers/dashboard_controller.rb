class DashboardController < TenantsController
  
  def index    
    @lichs = LichTrinhGiangDay.active.order('thoi_gian, phong')
  	respond_to do |format|
      format.html {render "index"} 
  	end
  end

  def lich
    @lich = LichTrinhGiangDay.find(params[:id])    
    @giang_vien = @lich.giang_vien   
    @lop = @lich.lop_mon_hoc
    respond_to do |format|     
      if current_user and Pundit.policy!(current_user, @lich).update?                         
        format.html {render "dashboard/teacher/lich"}          
      else
        @attendances = @lich.attendances.vang_hoac_tre
        @lich = @lich.decorate
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
  
  def daotao

    respond_to do |format|
        format.html {render "daotao/index"}
    end
  end

  def thanhtra

    respond_to do |format|
        format.html {render "thanhtra/index"}
    end
  end
end
