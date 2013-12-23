class LichTrinhGiangDaysController < ApplicationController
	def info
		lich = LichTrinhGiangDay.find(params[:lich_id])
		render json: LichTrinhGiangDaySerializer.new(lich), :root => false
	end
end