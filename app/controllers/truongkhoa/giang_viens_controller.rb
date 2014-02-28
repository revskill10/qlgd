class Truongkhoa::GiangViensController < TenantsController
	def lop
		
		respond_to do |format|
			format.html { render 'truongkhoa/lop' }
		end
	end
	def index
		@khoa = Khoa.find(params[:khoa_id])
		@gvs = GiangVien.where(ten_khoa: khoa.ten_khoa).includes(:assistants)	
		render json: {:giang_viens => @gvs}, :root => false
	end
end