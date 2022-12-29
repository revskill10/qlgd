class Daotao::GiangViensController < TenantsController
	def index
		@gvs = GiangVien.all.map {|gv| {:id => gv.id, :text => gv.hovaten + "- #{gv.ten_khoa}"}}		
		@mon_hocs = MonHoc.all.map {|mon| {:id => mon.id, :text => mon.ma_mon_hoc + " - " + mon.ten_mon_hoc} }.uniq
		render json: {:giang_viens => @gvs, :mon_hocs => @mon_hocs}, :root => false
	end
end