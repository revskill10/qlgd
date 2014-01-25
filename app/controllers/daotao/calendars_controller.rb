class Daotao::CalendarsController < TenantsController
	def index
		@lop = LopMonHoc.find(params[:lop_id])
		@headers = Tuan.pluck(:stt).uniq
		calendars = @lop.calendars.order(:tuan_hoc_bat_dau)
		@tuans = calendars.order('tuan_hoc_bat_dau, thu, tiet_bat_dau, giang_vien_id').group_by {|t| [t.tuan_hoc_bat_dau, t.so_tuan]}.keys.map{|t| (t[0]..t[0]+t[1]-1).to_a}
		@c = calendars.map {|ca| Daotao::CalendarSerializer.new(ca)}
		render json: {:tuans => @tuans.flatten, :headers => @headers, :calendars => @c}
	end

	def remove
		@lop = LopMonHoc.find(params[:lop_id])
		@calendar = @lop.calendars.find(params[:id])
		authorize @lop, :daotao?
		@calendar.remove! if @calendar.can_remove?

		@headers = Tuan.pluck(:stt).uniq
		calendars = @lop.calendars.order(:tuan_hoc_bat_dau)
		@tuans = calendars.order('tuan_hoc_bat_dau, thu, tiet_bat_dau, giang_vien_id').group_by {|t| [t.tuan_hoc_bat_dau, t.so_tuan]}.keys.map{|t| (t[0]..t[0]+t[1]-1).to_a}
		@c = calendars.map {|ca| Daotao::CalendarSerializer.new(ca)}
		render json: {:tuans => @tuans.flatten, :headers => @headers, :calendars => @c}
	end

	def restore
		@lop = LopMonHoc.find(params[:lop_id])
		@calendar = @lop.calendars.find(params[:id])
		authorize @lop, :daotao?
		@calendar.restore! if @calendar.can_restore?

		@headers = Tuan.pluck(:stt).uniq
		calendars = @lop.calendars.order(:tuan_hoc_bat_dau)
		@tuans = calendars.order('tuan_hoc_bat_dau, thu, tiet_bat_dau, giang_vien_id').group_by {|t| [t.tuan_hoc_bat_dau, t.so_tuan]}.keys.map{|t| (t[0]..t[0]+t[1]-1).to_a}
		@c = calendars.map {|ca| Daotao::CalendarSerializer.new(ca)}
		render json: {:tuans => @tuans.flatten, :headers => @headers, :calendars => @c}
	end

	def generate
		@lop = LopMonHoc.find(params[:lop_id])
		@calendar = @lop.calendars.find(params[:id])
		authorize @lop, :daotao?
		@calendar.generate! if @calendar.can_generate?

		@headers = Tuan.pluck(:stt).uniq
		calendars = @lop.calendars.order(:tuan_hoc_bat_dau)
		@tuans = calendars.order('tuan_hoc_bat_dau, thu, tiet_bat_dau, giang_vien_id').group_by {|t| [t.tuan_hoc_bat_dau, t.so_tuan]}.keys.map{|t| (t[0]..t[0]+t[1]-1).to_a}
		@c = calendars.map {|ca| Daotao::CalendarSerializer.new(ca)}
		render json: {:tuans => @tuans.flatten, :headers => @headers, :calendars => @c}
	end
end