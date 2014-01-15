class Daotao::SinhViensController < TenantsController

	def lop_hanh_chinhs
		svs = SinhVien.where(ma_lop_hanh_chinh: params[:ma_lop_hanh_chinh])
		render json: svs.map {|sv| {:id => sv.id, :code => sv.code, :hovaten => sv.hovaten}}, :root => false
	end

	def lop_mon_hocs
		@lop = LopMonHoc.find(params[:lop_mon_hoc_id])
		@enrollments = @lop.enrollments
		render json: @enrollments.map {|en| LopEnrollmentSerializer.new(en)}, :root => false
	end

	def show
		sv = SinhVien.find(params[:id])
	end
end