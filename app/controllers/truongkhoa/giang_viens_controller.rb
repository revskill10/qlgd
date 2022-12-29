class Truongkhoa::GiangViensController < TenantsController	
	def index
		@khoa = Khoa.find(params[:khoa_id])
		@gvs = GiangVien.order('encoded_position').where(ten_khoa: @khoa.ten_khoa).includes(:assistants)
		@results = @gvs.map {|gv| Truongkhoa::GiangVienSerializer.new(gv)}	
		render json: @results, :root => false
	end
end