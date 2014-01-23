class Daotao::GiangViensController < TenantsController
	def index
		@gvs = GiangVien.all.map {|gv| {:id => gv.id, :text => gv.code = " - " + gv.hovaten}}
		@mons = LopMonHoc.all.map {|lop| {:id => lop.ma_mon_hoc, :text => lop.ma_mon_hoc + " - " + lop.ten_mon_hoc} }.uniq
		@tenmons = LopMonHoc.all.map {|lop| {:id => lop.ten_mon_hoc, :text => lop.ten_mon_hoc} }.uniq
		render json: {:giang_viens => @gvs, :ma_mons => @mons, :ten_mon_hocs => @tenmons }, :root => false
	end
end