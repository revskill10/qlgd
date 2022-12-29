class Daotao::CalendarsController < TenantsController
	def index
		@lop = LopMonHoc.find(params[:lop_id])
		@headers = Tuan.pluck(:stt).uniq
		calendars = @lop.calendars.order(:tuan_hoc_bat_dau)
		@tuans = calendars.generated.order('tuan_hoc_bat_dau, thu, tiet_bat_dau, giang_vien_id').group_by {|t| [t.tuan_hoc_bat_dau, t.so_tuan]}.keys.map{|t| (t[0]..t[0]+t[1]-1).to_a}
		@c = calendars.map {|ca| Daotao::CalendarSerializer.new(ca)}
		@teachers = @lop.assistants.map {|t| {:id => t.giang_vien_id, :text => t.giang_vien.hovaten} }
		@phongs = Phong.all.map {|p| {:id => p.ma_phong, :text => p.ma_phong}}
		render json: {:tuans => @tuans.flatten, :headers => @headers, :calendars => @c, :giang_viens => @teachers, :phongs => @phongs}
	end

	def destroy
		@lop = LopMonHoc.find(params[:lop_id])
		@calendar = @lop.calendars.find(params[:id])
		authorize @lop, :daotao?
		@calendar.destroy

		@headers = Tuan.pluck(:stt).uniq
		calendars = @lop.calendars.order(:tuan_hoc_bat_dau)
		@tuans = calendars.generated.order('tuan_hoc_bat_dau, thu, tiet_bat_dau, giang_vien_id').group_by {|t| [t.tuan_hoc_bat_dau, t.so_tuan]}.keys.map{|t| (t[0]..t[0]+t[1]-1).to_a}
		@c = calendars.map {|ca| Daotao::CalendarSerializer.new(ca)}
		@teachers = @lop.assistants.map {|t| {:id => t.giang_vien_id, :text => t.giang_vien.hovaten} }
		@phongs = Phong.all.map {|p| {:id => p.ma_phong, :text => p.ma_phong}}
		render json: {:tuans => @tuans.flatten, :headers => @headers, :calendars => @c, :giang_viens => @teachers, :phongs => @phongs}
	end

	def remove
		@lop = LopMonHoc.find(params[:lop_id])
		@calendar = @lop.calendars.find(params[:id])
		authorize @lop, :daotao?
		@calendar.remove! if @calendar.can_remove?

		@headers = Tuan.pluck(:stt).uniq
		calendars = @lop.calendars.order(:tuan_hoc_bat_dau)
		@tuans = calendars.generated.order('tuan_hoc_bat_dau, thu, tiet_bat_dau, giang_vien_id').group_by {|t| [t.tuan_hoc_bat_dau, t.so_tuan]}.keys.map{|t| (t[0]..t[0]+t[1]-1).to_a}
		@c = calendars.map {|ca| Daotao::CalendarSerializer.new(ca)}
		@teachers = @lop.assistants.map {|t| {:id => t.giang_vien_id, :text => t.giang_vien.hovaten} }
		@phongs = Phong.all.map {|p| {:id => p.ma_phong, :text => p.ma_phong}}
		render json: {:tuans => @tuans.flatten, :headers => @headers, :calendars => @c, :giang_viens => @teachers, :phongs => @phongs}
	end

	def restore
		@lop = LopMonHoc.find(params[:lop_id])
		@calendar = @lop.calendars.find(params[:id])
		authorize @lop, :daotao?
		@calendar.restore! if @calendar.can_restore?

		@headers = Tuan.pluck(:stt).uniq
		calendars = @lop.calendars.order(:tuan_hoc_bat_dau)
		@tuans = calendars.generated.order('tuan_hoc_bat_dau, thu, tiet_bat_dau, giang_vien_id').group_by {|t| [t.tuan_hoc_bat_dau, t.so_tuan]}.keys.map{|t| (t[0]..t[0]+t[1]-1).to_a}
		@c = calendars.map {|ca| Daotao::CalendarSerializer.new(ca)}
		@teachers = @lop.assistants.map {|t| {:id => t.giang_vien_id, :text => t.giang_vien.hovaten} }
		@phongs = Phong.all.map {|p| {:id => p.ma_phong, :text => p.ma_phong}}
		render json: {:tuans => @tuans.flatten, :headers => @headers, :calendars => @c, :giang_viens => @teachers, :phongs => @phongs}
	end

	def generate
		@lop = LopMonHoc.find(params[:lop_id])
		@calendar = @lop.calendars.find(params[:id])
		authorize @lop, :daotao?
		@calendar.generate! if @calendar.can_generate?

		@headers = Tuan.pluck(:stt).uniq
		calendars = @lop.calendars.order(:tuan_hoc_bat_dau)
		@tuans = calendars.generated.order('tuan_hoc_bat_dau, thu, tiet_bat_dau, giang_vien_id').group_by {|t| [t.tuan_hoc_bat_dau, t.so_tuan]}.keys.map{|t| (t[0]..t[0]+t[1]-1).to_a}
		@c = calendars.map {|ca| Daotao::CalendarSerializer.new(ca)}
		@teachers = @lop.assistants.map {|t| {:id => t.giang_vien_id, :text => t.giang_vien.hovaten} }
		@phongs = Phong.all.map {|p| {:id => p.ma_phong, :text => p.ma_phong}}
		render json: {:tuans => @tuans.flatten, :headers => @headers, :calendars => @c, :giang_viens => @teachers, :phongs => @phongs}
	end

	def create
		@lop = LopMonHoc.find(params[:lop_id])		
		authorize @lop, :daotao?
		@lop.calendars.create(tuan_hoc_bat_dau: params[:tuan_hoc_bat_dau], so_tuan: params[:so_tuan], thu: params[:thu], tiet_bat_dau: params[:tiet_bat_dau], so_tiet: params[:so_tiet], phong: params[:phong], giang_vien_id: params[:giang_vien_id])
		@headers = Tuan.pluck(:stt).uniq
		calendars = @lop.calendars.order(:tuan_hoc_bat_dau)
		@tuans = calendars.generated.order('tuan_hoc_bat_dau, thu, tiet_bat_dau, giang_vien_id').group_by {|t| [t.tuan_hoc_bat_dau, t.so_tuan]}.keys.map{|t| (t[0]..t[0]+t[1]-1).to_a}
		@c = calendars.map {|ca| Daotao::CalendarSerializer.new(ca)}
		@teachers = @lop.assistants.map {|t| {:id => t.giang_vien_id, :text => t.giang_vien.hovaten} }
		@phongs = Phong.all.map {|p| {:id => p.ma_phong, :text => p.ma_phong}}
		render json: {:tuans => @tuans.flatten, :headers => @headers, :calendars => @c, :giang_viens => @teachers, :phongs => @phongs}
	end
end