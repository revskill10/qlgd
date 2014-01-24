class Daotao::CalendarsController < TenantsController
	def index
		@lop = LopMonHoc.find(params[:lop_id])
		@headers = Tuan.pluck(:stt).uniq
		calendars = @lop.calendars.order(:tuan_hoc_bat_dau)
		@tuans = calendars.group_by {|t| [t.tuan_hoc_bat_dau, t.so_tuan]}.keys.map{|t| (t[0]..t[0]+t[1]).to_a}
		@c = calendars.map {|ca| Daotao::CalendarSerializer.new(ca)}
		render json: {:tuans => @tuans.flatten, :headers => @headers, :calendars => @c}
	end
end