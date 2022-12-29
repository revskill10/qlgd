class Daotao::LichTrinhGiangDaysController < TenantsController

	def index
		@lichs = LichTrinhGiangDay.waiting.map {|l| Daotao::LichTrinhGiangDaySerializer.new(Daotao::LichTrinhGiangDayDecorator.new(l))}
		render json: @lichs, :root => false
	end

	def accept
		@lich = LichTrinhGiangDay.find(params[:id])
		authorize @lich, :daotao?
		@lich.phong = params[:phong] if @lich.state == 'bosung'
		@lich.accept!
		@lichs = LichTrinhGiangDay.waiting.map {|l| Daotao::LichTrinhGiangDaySerializer.new(Daotao::LichTrinhGiangDayDecorator.new(l))}
		render json: @lichs, :root => false
	end

	def drop
		@lich = LichTrinhGiangDay.find(params[:id])
		authorize @lich, :daotao?		
		if @lich.state == "nghiday"
			@lich.update_attributes(state: "normal")
			@lich.accept!
		else
			@lich.drop! if @lich.can_drop?
		end
		@lichs = LichTrinhGiangDay.waiting.map {|l| Daotao::LichTrinhGiangDaySerializer.new(Daotao::LichTrinhGiangDayDecorator.new(l))}
		render json: @lichs, :root => false
	end

	def check
		@lich = LichTrinhGiangDay.find(params[:id])
		authorize @lich, :daotao?
		temp = LichTrinhGiangDay.includes(:vi_pham).select {|l| @lich.conflict?(l)}
		temp2 = LichTrinhGiangDay.includes(:vi_pham).select {|l| @lich.conflict_sinh_vien?(l)}
		@lichs = temp.map {|l| Daotao::LichTrinhGiangDaySerializer.new(Daotao::LichTrinhGiangDayDecorator.new(l))}
		@sinh_vien_trungs = temp2.inject([]) {|res, elem| res += (elem.sinh_viens & @lich.sinh_viens )}.uniq.map {|sv| SinhVienSerializer.new(sv)}
		
		render json: {:lich => @lichs, :sinh_vien => @sinh_vien_trungs}, :root => false
	end

	def daduyet
		@lichs = LichTrinhGiangDay.daduyet.map {|l| Daotao::LichTrinhGiangDaySerializer.new(Daotao::LichTrinhGiangDayDecorator.new(l))}
		render json: @lichs, :root => false
	end

	
end