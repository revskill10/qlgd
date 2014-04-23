#encoding: utf-8
class Teacher::GroupSubmissionsController < TenantsController	
	def index
		@lop = LopMonHoc.find(params[:id])
		
		sql = "with a1 as (select en.id, ai.id as assignment_group_id, ai.name from enrollments en
inner join assignment_groups ai on ai.lop_mon_hoc_id = en.lop_mon_hoc_id
where en.lop_mon_hoc_id=#{@lop.id}),a2 as (select su.enrollment_id, su.grade, ai.id as assignment_group_id, ai.name from group_submissions su
inner join assignment_groups ai on su.assignment_group_id=ai.id
inner join lop_mon_hocs lop on ai.lop_mon_hoc_id = lop.id
where lop.id=#{@lop.id}),a3 as (select a1.id, a1.assignment_group_id, a1.name, COALESCE(a2.grade,0) as grade from a1
left outer join a2 on a1.id = a2.enrollment_id and a1.assignment_group_id = a2.assignment_group_id)
select a3.id as enrollment_id, a3.assignment_group_id, a3.name, a3.grade, regexp_replace(sv.ho || ' ' || sv.dem || ' ' || sv.ten, '  ',' ') as hovaten, sv.code, sv.ma_lop_hanh_chinh, COALESCE(en.diem_qua_trinh,0) as diem_qua_trinh, en.tinhhinh  from a3 inner join enrollments en on en.id = a3.id
inner join lop_mon_hocs lop on lop.id = en.lop_mon_hoc_id 
inner join sinh_viens sv on sv.id = en.sinh_vien_id
inner join assignment_groups ai on a3.assignment_group_id = ai.id
order by sv.encoded_position, ai.position
"
		results = ActiveRecord::Base.connection.execute(sql).group_by {|k| [k["enrollment_id"],k["hovaten"],k["code"],k["ma_lop_hanh_chinh"],k["diem_qua_trinh"], k["tinhhinh"]]}.map {|k,v| {:enrollment_group_id => k[0], :hovaten => k[1], :code => k[2], :ma_lop_hanh_chinh => k[3], :diem_qua_trinh => k[4], :tinhhinh => k[5], :group_submissions => v}}
		sql2 = "select ag.id as assignment_group_id, ag.name as group_name, ag.weight from assignment_groups ag
where ag.lop_mon_hoc_id=#{@lop.id}
order by ag.position"
		headers = ActiveRecord::Base.connection.execute(sql2).map {|k| {:assignment_group_id => k["assignment_group_id"], :group_name => k["group_name"], :weight => k["weight"] }}
		render json: {:results => results, :headers => headers}, :root => false
	end
end