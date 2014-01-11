#encoding: utf-8
class Teacher::SubmissionsController < TenantsController	
	def index2
		@lop = LopMonHoc.find(params[:id])
		
		sql = "with a1 as (select en.id, ai.id as assignment_id, ai.name from enrollments en
inner join assignments ai on ai.lop_mon_hoc_id = en.lop_mon_hoc_id
where en.lop_mon_hoc_id=#{@lop.id}), a2 as (select su.enrollment_id, su.grade, ai.id as assignment_id, ai.name from submissions su
inner join assignments ai on su.assignment_id=ai.id
inner join lop_mon_hocs lop on ai.lop_mon_hoc_id = lop.id
where lop.id=#{@lop.id}), a3 as (select a1.id, a1.assignment_id, a1.name, COALESCE(a2.grade,0) as grade from a1
left outer join a2 on a1.id = a2.enrollment_id and a1.assignment_id = a2.assignment_id)
select a3.id as enrollment_id, a3.assignment_id, a3.name, a3.grade, regexp_replace(sv.ho || ' ' || sv.dem || ' ' || sv.ten, '  ',' ') as hovaten, sv.code, sv.ma_lop_hanh_chinh  from a3 inner join enrollments en on en.id = a3.id
inner join lop_mon_hocs lop on lop.id = en.lop_mon_hoc_id 
inner join sinh_viens sv on sv.id = en.sinh_vien_id;"
		results = ActiveRecord::Base.connection.execute(sql).group_by {|k| [k["enrollment_id"],k["hovaten"],k["code"],k["ma_lop_hanh_chinh"]]}.map {|k,v| {:enrollment_id => k[0], :hovaten => k[1], :code => k[2], :ma_lop_hanh_chinh => k[3], :submissions => v}}
		sql2 = "select ai.id as assignment_id, ai.name, ai.points, ag.name as group_name, ag.weight from assignments ai
inner join assignment_groups ag on ag.id = ai.assignment_group_id
where ai.lop_mon_hoc_id=#{@lop.id}"
		headers = ActiveRecord::Base.connection.execute(sql2).map {|k| {:assignment_id => k["assignment_id"], :assignment_name => k["name"], :points => k["points"], :group_name => k["group_name"], :weight => k["weight"] }}
		render json: {:results => results, :headers => headers}, :root => false
	end
	def index
		@lop = LopMonHoc.find(params[:id])
		assignments = @lop.assignment_groups.includes(:assignments).inject([]) {|res, el| res + el.assignments}
		count = 0
		names = assignments.map {|a| {:name => a.name, :points => a.points, :group_name => a.assignment_group.name, :group_weight => a.assignment_group.weight}}
		enrollments = @lop.enrollments
		results = enrollments.map do |en|
			tmp = {:id => en.id ,:name => en.sinh_vien.hovaten, :assignments => []}			
			assignments.each_with_index do |as, index|				
				tmp[:assignments] << EnrollmentSubmissionSerializer.new(EnrollmentSubmissionDecorator.new(en, as, index + count))
			end
			count += assignments.count
			tmp
		end
		group_names = @lop.assignment_groups.map { |g|
			{:name => g.name, :weight => g.weight}
		}
		group_results = enrollments.map do |en|
			tmp = {:id => en.id, :name => en.sinh_vien.hovaten, :assignment_groups => [], :diem_qua_trinh => en.diem_qua_trinh}			
			@lop.assignment_groups.each do |ag|				
				tmp[:assignment_groups] << EnrollmentGroupSubmissionSerializer.new(EnrollmentGroupSubmissionDecorator.new(en, ag))
			end
			
			tmp
		end
	    render json: {:names => names, :results => results, :group_results => group_results, :group_names => group_names }.to_json		
	end
	def update2
		@lop = LopMonHoc.find(params[:lop_id])
		authorize @lop, :update?
		@as= @lop.assignments.find(params[:assignment_id])
		@sub = @as.submissions.where(enrollment_id: params[:enrollment_id]).first
		if @sub
			@sub.grade = params[:grade]
			@sub.save!
		else
			@sub = @as.submissions.create(enrollment_id: params[:enrollment_id], grade: params[:grade])
		end
		sql = "with a1 as (select en.id, ai.id as assignment_id, ai.name from enrollments en
inner join assignments ai on ai.lop_mon_hoc_id = en.lop_mon_hoc_id
where en.lop_mon_hoc_id=#{@lop.id}), a2 as (select su.enrollment_id, su.grade, ai.id as assignment_id, ai.name from submissions su
inner join assignments ai on su.assignment_id=ai.id
inner join lop_mon_hocs lop on ai.lop_mon_hoc_id = lop.id
where lop.id=#{@lop.id}), a3 as (select a1.id, a1.assignment_id, a1.name, COALESCE(a2.grade,0) as grade from a1
left outer join a2 on a1.id = a2.enrollment_id and a1.assignment_id = a2.assignment_id)
select a3.id as enrollment_id, a3.assignment_id, a3.name, a3.grade, regexp_replace(sv.ho || ' ' || sv.dem || ' ' || sv.ten, '  ',' ') as hovaten, sv.code, sv.ma_lop_hanh_chinh  from a3 inner join enrollments en on en.id = a3.id
inner join lop_mon_hocs lop on lop.id = en.lop_mon_hoc_id 
inner join sinh_viens sv on sv.id = en.sinh_vien_id;"
		results = ActiveRecord::Base.connection.execute(sql).group_by {|k| [k["enrollment_id"],k["hovaten"],k["code"],k["ma_lop_hanh_chinh"]]}.map {|k,v| {:enrollment_id => k[0], :hovaten => k[1], :code => k[2], :ma_lop_hanh_chinh => k[3], :submissions => v}}
		sql2 = "select ai.id as assignment_id, ai.name, ai.points, ag.name as group_name, ag.weight from assignments ai
inner join assignment_groups ag on ag.id = ai.assignment_group_id
where ai.lop_mon_hoc_id=#{@lop.id}"
		headers = ActiveRecord::Base.connection.execute(sql2).map {|k| {:assignment_id => k["assignment_id"], :assignment_name => k["name"], :points => k["points"], :group_name => k["group_name"], :weight => k["weight"] }}
		render json: {:results => results, :headers => headers}, :root => false
	end
	# post grades
	def update
		@lop = LopMonHoc.find(params[:id])
		authorize @lop, :update?
		@as= @lop.assignments.find(params[:assignment_id])
		@sub = @as.submissions.where(sinh_vien_id: params[:sinh_vien_id]).first
		if @sub
			@sub.grade = params[:grade]
			@sub.save!
		else
			@sub = @as.submissions.create(sinh_vien_id: params[:sinh_vien_id], grade: params[:grade])
		end

		assignments = @lop.assignment_groups.includes(:assignments).inject([]) {|res, el| res + el.assignments}
		count = 0		
		names = assignments.map {|a| {:name => a.name, :points => a.points, :group_name => a.assignment_group.name, :group_weight => a.assignment_group.weight}}
		group_names = @lop.assignment_groups.map { |g|
			{:name => g.name, :weight => g.weight}
		}
		enrollments = @lop.enrollments
		results = enrollments.map do |en|
			tmp = {:id => en.id, :name => en.sinh_vien.hovaten, :assignments => []}					
			assignments.each_with_index do |as, index|				
				tmp[:assignments] << EnrollmentSubmissionSerializer.new(EnrollmentSubmissionDecorator.new(en, as, index + count))
			end
			count += assignments.count
			tmp
		end

	    group_results = enrollments.map do |en|
			tmp = {:id => en.id ,:name => en.sinh_vien.hovaten, :assignment_groups => [], :diem_qua_trinh => en.diem_qua_trinh}			
			@lop.assignment_groups.each do |ag|				
				tmp[:assignment_groups] << EnrollmentGroupSubmissionSerializer.new(EnrollmentGroupSubmissionDecorator.new(en, ag))
			end
			
			tmp
		end
	    render json: {:names => names, :results => results, :group_results => group_results, :group_names => group_names }.to_json	
	end
end