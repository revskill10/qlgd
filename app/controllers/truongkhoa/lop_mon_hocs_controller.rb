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