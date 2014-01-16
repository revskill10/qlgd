class Daotao::LichTrinhGiangDaysController < TenantsController

	def index
		@lichs = LichTrinhGiangDay.waiting.map {|l| LichTrinhGiangDaySerializer.new(l.decorate)}
		render json: @lichs, :root => false
	end

	def accept
		@lich = LichTrinhGiangDay.find(params[:id])
		authorize @lich, :daotao?
		@lich.phong = params[:phong] if @lich.ltype == 'bosung'
		@lich.accept!
		@lichs = LichTrinhGiangDay.waiting.map {|l| LichTrinhGiangDaySerializer.new(l.decorate)}
		render json: @lichs, :root => false
	end

	def drop
		@lich = LichTrinhGiangDay.find(params[:id])
		authorize @lich, :daotao?
		@lich.drop!
		@lichs = LichTrinhGiangDay.waiting.map {|l| LichTrinhGiangDaySerializer.new(l.decorate)}
		render json: @lichs, :root => false
	end

	def check
		@lich = LichTrinhGiangDay.find(params[:id])
		authorize @lich, :daotao?
		@lichs = LichTrinhGiangDay.select {|l| @lich.conflict?(l)}.map {|l| LichTrinhGiangDaySerializer.new(l.decorate)}
		render json: @lichs, :root => false
	end

	def daduyet
		@lichs = LichTrinhGiangDay.daduyet.map {|l| LichTrinhGiangDaySerializer.new(l.decorate)}
		render json: @lichs, :root => false
	end
end