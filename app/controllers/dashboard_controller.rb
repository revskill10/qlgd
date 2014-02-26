class DashboardController < TenantsController
  
  def index    
    @lichs = LichTrinhGiangDay.includes(:attendances).includes(:lop_mon_hoc => :enrollments).active.order('thoi_gian, phong')
  	respond_to do |format|
      format.html {render "index"} 
      format.mobile {render "index"}
      format.tablet {render "index"}
  	end
  end

  def lich
    @lich = LichTrinhGiangDay.find(params[:id])    
    @giang_vien = @lich.giang_vien   
    @lop = @lich.lop_mon_hoc
    respond_to do |format|     
      if current_user and Pundit.policy!(current_user, @lich).update?                         
        format.html {render "dashboard/teacher/lich"}
        if is_mobile_device? or is_tablet_device?
          format.mobile {render "dashboard/teacher/lich"}
          format.tablet {render "dashboard/teacher/lich"}
        end          
      else
        @attendances = @lich.attendances.vang_hoac_tre
        @lich = @lich.decorate
        format.html {render "dashboard/student/lich"}
        if is_mobile_device? or is_tablet_device?
          format.mobile {render "dashboard/student/lich"}
          format.tablet {render "dashboard/student/lich"}
        end
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
        sql = "with a1 as (select en.id, ai.id as assignment_group_id, ai.name from t2.enrollments en
inner join t2.assignment_groups ai on ai.lop_mon_hoc_id = en.lop_mon_hoc_id
where en.lop_mon_hoc_id=#{@lop.id}),a2 as (select su.enrollment_id, su.grade, ai.id as assignment_group_id, ai.name from t2.group_submissions su
inner join t2.assignment_groups ai on su.assignment_group_id=ai.id
inner join t2.lop_mon_hocs lop on ai.lop_mon_hoc_id = lop.id
where lop.id=#{@lop.id}),a3 as (select a1.id, a1.assignment_group_id, a1.name, COALESCE(a2.grade,0) as grade from a1
left outer join a2 on a1.id = a2.enrollment_id and a1.assignment_group_id = a2.assignment_group_id)
select lop.id as lop_id, a3.id as enrollment_id, a3.assignment_group_id, a3.name, a3.grade, regexp_replace(sv.ho || ' ' || sv.dem || ' ' || sv.ten, '  ',' ') as hovaten, sv.id as sinh_vien_id, en.tong_tiet_vang as tong_tiet_vang, sv.code, sv.ma_lop_hanh_chinh, COALESCE(en.diem_qua_trinh,0) as diem_qua_trinh, en.tinhhinh  from a3 inner join t2.enrollments en on en.id = a3.id
inner join t2.lop_mon_hocs lop on lop.id = en.lop_mon_hoc_id 
inner join t2.sinh_viens sv on sv.id = en.sinh_vien_id
inner join t2.assignment_groups ai on a3.assignment_group_id = ai.id
order by sv.position, ai.position
"
    @results = ActiveRecord::Base.connection.execute(sql).group_by {|k| [ k["enrollment_id"],k["hovaten"],k["code"],k["ma_lop_hanh_chinh"],k["diem_qua_trinh"], k["tinhhinh"], k["tong_tiet_vang"], k["sinh_vien_id"]]}.map {|k,v| {:enrollment_group_id => k[0], :hovaten => k[1], :code => k[2], :ma_lop_hanh_chinh => k[3], :diem_qua_trinh => k[4], :tinhhinh => k[5], :tong_tiet_vang => k[6], :sinh_vien_id => k[7], :group_submissions => v}}
    sql2 = "select ag.id as assignment_group_id, ag.name as group_name, ag.weight from assignment_groups ag
where ag.lop_mon_hoc_id=#{@lop.id}
order by ag.position"
    @headers = ActiveRecord::Base.connection.execute(sql2).map {|k| {:assignment_group_id => k["assignment_group_id"], :group_name => k["group_name"], :weight => k["weight"] }}
        format.html {render "dashboard/student/lop"}
        if is_mobile_device? or is_tablet_device?
          format.mobile {render "dashboard/student/lop"}
          format.tablet {render "dashboard/student/lop"}
        end
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
      format.mobile {render "dashboard/student/show"}
      format.tablet {render "dashboard/student/show"}
    end   
  end

  def giang_vien
    @giang_vien = GiangVien.includes(:assistants).find(params[:giang_vien_id])
    @assistants = @giang_vien.assistants.includes(:lop_mon_hoc)    
    @lichs = @assistants.select {|as| as if as.lop_mon_hoc and !as.lop_mon_hoc.removed? }.uniq.inject([]) {|res, elem| res + elem.lop_mon_hoc.lich_trinh_giang_days.includes(:attendances)}.sort_by {|l| [l.thoi_gian, l.phong]}
    respond_to do |format|
      format.html {render "dashboard/teacher/show"}
      format.mobile {render "dashboard/teacher/show"}
      format.tablet {render "dashboard/teacher/show"}
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
      format.mobile {render "dashboard/search/non_query"}
      format.tablet {render "dashboard/search/non_query"}
    end
  end
end
