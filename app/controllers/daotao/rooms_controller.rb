class Daotao::RoomsController < TenantsController

	def idle
		date = Date.strptime(params[:date], '%d/%m/%Y')
		tomorrow = date + 1.day
		@lichs = LichTrinhGiangDay.where(["thoi_gian > ? and thoi_gian < ?", date.to_time.utc, tomorrow.to_time.utc])
		empty_room = Phong.pluck(:ma_phong).uniq - @lichs.pluck(:phong).uniq
		@empty_lichs = empty_room.inject([]) {|arr, item| arr << {:phong => item, :data => []}}
		@lichs2 = @lichs.map {|l| Daotao::LichTrinhGiangDaySerializer.new(l)}.group_by {|l| l.phong}.select {|l| l}.inject([]) {|arr, (k,v)| arr << {:phong => k, :data => v.sort_by{|v1| v1.ca}}}
		@result = (@empty_lichs + @lichs2).sort_by {|item| item[:phong]}
		render json: @result, :root => false
	end
end