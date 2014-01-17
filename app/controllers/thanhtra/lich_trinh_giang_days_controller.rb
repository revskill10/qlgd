class Thanhtra::LichTrinhGiangDaysController < TenantsController

	def index
		date = Date.strptime(params[:date], '%d/%m/%Y')
		tomorrow = date + 1.day
		@lichs = LichTrinhGiangDay.thanhtra.where(["thoi_gian > ? and thoi_gian < ?", date.to_time.utc, tomorrow.to_time.utc]).map {|l| LichViPhamSerializer.new( LichViPhamDecorator.new(l) )}
		render json: @lichs, :root => false
	end

end