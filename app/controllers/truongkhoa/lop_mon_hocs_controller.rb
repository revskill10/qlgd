#encoding: utf-8
class Truongkhoa::LopMonHocsController < TenantsController	
	def show
		@lop = LopMonHoc.find(params[:lop_id])
		@result = Truongkhoa::LopMonHocSerializer.new(@lop)
		render json: @result
	end
	def lichtrinh
		@lop = LopMonHoc.find(params[:lop_id])
		@lichs = @lop.lich_trinh_giang_days
			.where('thoi_gian < ?', Time.now)
			.order('tuan, thoi_gian')
			.map {|lich| Truongkhoa::LichTrinhGiangDaysSerializer.new(lich)}.group_by {|l| l.tuan}
			.map {|k,v| 
				{:tuan => k, :noi_dung => v.inject("") {|res, elem| res + (elem.noi_dung || "") + "\n"}, :so_tiet => v.inject(0) {|res, elem| res + elem.so_tiet_moi}, :thoi_gian => v.inject("") {|res, elem| res + elem.thoi_gian.localtime.strftime("%H:%M %d/%m/%Y") + "\n"}
				}		
			}
		render json: @lichs, :root => false
	end
	def tinhhinh
		@lop = LopMonHoc.find(params[:lop_id])
		x = (1..16)
		if Tenant.first.hoc_ky == '2'
			x = (23..41)
		end
		headers = x.inject([]){|res, elem| res << {tuan: "Tuần #{elem}"} }		
		str1 = ""
		x.each do |t|
			str1 += ",sum(case when tuan=#{t} then stv else 0 end) as \"Tuần #{t}\""
		end
		str2 = ""
		x.each do |t|
			str2 += ", 0 as \"Tuần #{t}\""
		end
		sql = "select hovaten, code, ma_lop_hanh_chinh, enrollment_id, encoded_position #{str1}
from (
select sum(so_tiet_vang) as stv, enrollment_id, encoded_position, tuan, hovaten, code, ma_lop_hanh_chinh
from (
SELECT regexp_replace(sv.ho || ' ' || sv.dem || ' ' || sv.ten, '  ',' ') as hovaten, sv.code, sv.ma_lop_hanh_chinh, at.so_tiet_vang, lp.id as lop_mon_hoc_id, en.id as enrollment_id, sv.encoded_position as encoded_position, lt.tuan
  FROM t2.attendances at
  inner join t2.lich_trinh_giang_days lt on at.lich_trinh_giang_day_id=lt.id
  inner join t2.lop_mon_hocs lp on lp.id = lt.lop_mon_hoc_id
  inner join t2.sinh_viens sv on at.sinh_vien_id=sv.id
  inner join t2.enrollments en on en.sinh_vien_id=sv.id and en.lop_mon_hoc_id=lp.id
  where lp.id=#{@lop.id} and at.so_tiet_vang > 0
  order by lt.tuan) at
  group by tuan, lop_mon_hoc_id, enrollment_id, encoded_position, hovaten, code, ma_lop_hanh_chinh
  order by tuan) at2
  group by enrollment_id, encoded_position, hovaten, code, ma_lop_hanh_chinh  
union all
  select regexp_replace(sv.ho || ' ' || sv.dem || ' ' || sv.ten, '  ',' ') as hovaten, sv.code, sv.ma_lop_hanh_chinh, en.id as enrollment_id, sv.encoded_position #{str2}
  from t2.enrollments en
  inner join t2.sinh_viens sv on sv.id= en.sinh_vien_id
  where en.lop_mon_hoc_id=#{@lop.id}
order by encoded_position"
		@results = ActiveRecord::Base.connection.execute(sql)
		@results = @results.map do |item|
			tmp = []
			item.each do |k,v|				
				if k =~ /Tuần/
					tmp << v
				end				
			end
			item[:data] = tmp
			item
		end
		render json: {data: @results, headers: headers}
	end
	def update
		@lop = LopMonHoc.find(params[:lop_id])
		case params[:type]
		when "1"
			if params[:maction] == "1"
				@lop.update_attributes(duyet_thong_so: true)
			else
				@lop.update_attributes(duyet_thong_so: false)
			end
		when "2"
			if params[:maction] == "1"
				@lop.update_attributes(duyet_lich_trinh: true)
			else
				@lop.update_attributes(duyet_lich_trinh: false)
			end
		when "3"
			if params[:maction] == "1"
				@lop.update_attributes(duyet_tinh_hinh: true)
			else
				@lop.update_attributes(duyet_tinh_hinh: false)
			end
		end
		@result = Truongkhoa::LopMonHocSerializer.new(@lop)
		render json: @result
	end
end