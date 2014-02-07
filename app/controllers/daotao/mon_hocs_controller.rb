class Daotao::MonHocsController < TenantsController
	def create
		MonHoc.where(ma_mon_hoc: params[:ma_mon_hoc], ten_mon_hoc: params[:ten_mon_hoc]).first_or_create!
		@gvs = GiangVien.all.map {|gv| {:id => gv.id, :text => gv.code = " - " + gv.hovaten}}		
		@mon_hocs = MonHoc.all.map {|mon| {:id => mon.id, :text => mon.ma_mon_hoc + " - " + mon.ten_mon_hoc} }.uniq
		render json: {:giang_viens => @gvs, :mon_hocs => @mon_hocs}, :root => false
	end
end