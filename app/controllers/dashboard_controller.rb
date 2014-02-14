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

  def sinh_vien
    @sinh_vien = SinhVien.find(params[:sinh_vien_id]) 
    @enrollments = @sinh_vien.enrollments.includes(:lop_mon_hoc).select {|en| !en.lop_mon_hoc.nil?} 
    @lops = @enrollments.map {|en| en.lop_mon_hoc if en.lop_mon_hoc and !en.lop_mon_hoc.removed? }.select {|l| !l.nil? }.uniq
    @lichs = @lops.inject([]) {|res, elem| res + elem.lich_trinh_giang_days.includes(:attendances)}.sort_by {|l| [l.thoi_gian, l.phong]}
    respond_to do |format|
      format.html {render "dashboard/student/show"}
    end   
  end

  def giang_vien
    @giang_vien = GiangVien.find(params[:giang_vien_id])
    @assistants = @giang_vien.assistants.includes(:lop_mon_hoc => :lich_trinh_giang_days)
    @lops = @assistants.map {|as| as.lop_mon_hoc if as.lop_mon_hoc and !as.lop_mon_hoc.removed?}.select {|l| !l.nil? }.uniq
    @lichs = @lops.inject([]) {|res, elem| res + elem.lich_trinh_giang_days.includes(:attendances)}.sort_by {|l| [l.thoi_gian, l.phong]}
    respond_to do |format|
      format.html {render "dashboard/teacher/show"}
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
