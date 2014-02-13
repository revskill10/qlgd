class DashboardController < TenantsController
  
  def index    
    @lichs = LichTrinhGiangDay.includes(:attendances).includes(:lop_mon_hoc => :enrollments).active.order('thoi_gian, phong')
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

  def search
    @page = params[:page] || 1
    @type = params[:mtype] || 1
    @query = params[:query]
    respond_to do |format|
      if params[:query]
        if params[:mtype].to_i == 1          
          @search = Sunspot.search(SinhVien) do      
            fulltext params[:query]
            paginate(:page => params[:page] || 1, :per_page => 50)
          end
          @results = @search.results
          @ids = @results.map(&:id)
          @sinhviens2 = SinhVien.includes(:enrollments).find(@ids)
          @sinhviens = @sinhviens2.map {|res| SinhVienDecorator.new(res)}
        elsif  params[:mtype].to_i == 2
          @search = Sunspot.search(LopMonHoc) do      
            fulltext params[:query]
            paginate(:page => params[:page] || 1, :per_page => 50)
          end
          @results = @search.results
          @ids = @results.map(&:id)
          @lop_mon_hocs = LopMonHoc.includes(:assistants).includes(:enrollments).find(@ids).map {|res| SearchLopMonHocDecorator.new(res)}          
        elsif  params[:mtype].to_i == 3
          @search = Sunspot.search(LichTrinhGiangDay) do      
            fulltext params[:query]
            paginate(:page => params[:page] || 1, :per_page => 50)
          end
          @results = @search.results
          @ids = @results.map(&:id)
          @lichs = LichTrinhGiangDay.includes(:lop_mon_hoc).includes(:giang_vien).find(@ids)
        end            
      end
      format.html {render "dashboard/search/non_query"}
    end
  end
end
