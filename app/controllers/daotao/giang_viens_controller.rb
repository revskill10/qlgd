class Daotao::GiangViensController < TenantsController
	def index
		@gvs = GiangVien.all.map {|gv| {:id => gv.id, :text => gv.code = " - " + gv.hovaten}}
		render json: @gvs, :root => false
	end
end