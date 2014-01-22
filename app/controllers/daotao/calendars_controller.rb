class Daotao::CalendarsController < TenantsController
	def index
		@lop = LopMonHoc.find(params[:lop_id])
		@tuans = Tuan.all.map {|tuan| TuanSerializer.new(tuan.decorate)}
		@calendars = @lop.calendars.map {|calendar| CalendarSerializer.new(calendar)}
		render json: {:tuans => @tuans, :calendars => @calendars}
	end
end