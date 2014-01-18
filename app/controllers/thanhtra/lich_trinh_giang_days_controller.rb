class Thanhtra::LichTrinhGiangDaysController < TenantsController

	def index
		date = Date.strptime(params[:date], '%d/%m/%Y')
		tomorrow = date + 1.day
		@lichs = LichTrinhGiangDay.thanhtra.where(["thoi_gian > ? and thoi_gian < ?", date.to_time.utc, tomorrow.to_time.utc]).map {|l| LichViPhamSerializer.new( LichViPhamDecorator.new(l) )}
		render json: @lichs, :root => false
	end
	def update
		@lich = LichTrinhGiangDay.find(params[:lich_id])
		authorize @lich, :thanhtra?
		if @lich.vi_pham			
			@vi_pham = @lich.vi_pham
			@vi_pham.note1 = params[:note1] 
			@vi_pham.note3 = params[:note3]
			@vi_pham.save!
		else
			@vi_pham = @lich.build_vi_pham(note1: params[:note1], note3: params[:note3])			
			@vi_pham.save!
		end

		date = Date.strptime(params[:date], '%d/%m/%Y')
		tomorrow = date + 1.day
		@lichs = LichTrinhGiangDay.thanhtra.where(["thoi_gian > ? and thoi_gian < ?", date.to_time.utc, tomorrow.to_time.utc]).map {|l| LichViPhamSerializer.new( LichViPhamDecorator.new(l) )}
		render json: @lichs, :root => false
	end
	def dimuon
		@lich = LichTrinhGiangDay.find(params[:lich_id])
		authorize @lich, :thanhtra?
		if @lich.vi_pham			
			@vi_pham = @lich.vi_pham
		else
			@vi_pham = @lich.build_vi_pham
		end
		@vi_pham.di_muon = !@vi_pham.di_muon
		@vi_pham.save!
		date = Date.strptime(params[:date], '%d/%m/%Y')
		tomorrow = date + 1.day
		@lichs = LichTrinhGiangDay.thanhtra.where(["thoi_gian > ? and thoi_gian < ?", date.to_time.utc, tomorrow.to_time.utc]).map {|l| LichViPhamSerializer.new( LichViPhamDecorator.new(l) )}
		render json: @lichs, :root => false
	end

	def vesom
		@lich = LichTrinhGiangDay.find(params[:lich_id])
		authorize @lich, :thanhtra?
		if @lich.vi_pham			
			@vi_pham = @lich.vi_pham
		else
			@vi_pham = @lich.build_vi_pham
		end
		@vi_pham.ve_som = !@vi_pham.ve_som
		@vi_pham.save!
		date = Date.strptime(params[:date], '%d/%m/%Y')
		tomorrow = date + 1.day
		@lichs = LichTrinhGiangDay.thanhtra.where(["thoi_gian > ? and thoi_gian < ?", date.to_time.utc, tomorrow.to_time.utc]).map {|l| LichViPhamSerializer.new( LichViPhamDecorator.new(l) )}
		render json: @lichs, :root => false
	end

	def botiet
		@lich = LichTrinhGiangDay.find(params[:lich_id])
		authorize @lich, :thanhtra?
		if @lich.vi_pham			
			@vi_pham = @lich.vi_pham
		else
			@vi_pham = @lich.build_vi_pham
		end
		@vi_pham.bo_tiet = !@vi_pham.bo_tiet
		@vi_pham.save!
		date = Date.strptime(params[:date], '%d/%m/%Y')
		tomorrow = date + 1.day
		@lichs = LichTrinhGiangDay.thanhtra.where(["thoi_gian > ? and thoi_gian < ?", date.to_time.utc, tomorrow.to_time.utc]).map {|l| LichViPhamSerializer.new( LichViPhamDecorator.new(l) )}
		render json: @lichs, :root => false
	end

	def report
		@lich = LichTrinhGiangDay.find(params[:lich_id])
		authorize @lich, :thanhtra?
		if @lich.vi_pham			
			@vi_pham = @lich.vi_pham
		else
			@vi_pham = @lich.build_vi_pham
		end
		@vi_pham.report! if @vi_pham.can_report?		
		date = Date.strptime(params[:date], '%d/%m/%Y')
		tomorrow = date + 1.day
		@lichs = LichTrinhGiangDay.thanhtra.where(["thoi_gian > ? and thoi_gian < ?", date.to_time.utc, tomorrow.to_time.utc]).map {|l| LichViPhamSerializer.new( LichViPhamDecorator.new(l) )}
		render json: @lichs, :root => false
	end

	def unreport
		@lich = LichTrinhGiangDay.find(params[:lich_id])
		authorize @lich, :thanhtra?
		if @lich.vi_pham			
			@vi_pham = @lich.vi_pham
		else
			@vi_pham = @lich.build_vi_pham
		end
		@vi_pham.unreport! if @vi_pham.can_unreport?		
		date = Date.strptime(params[:date], '%d/%m/%Y')
		tomorrow = date + 1.day
		@lichs = LichTrinhGiangDay.thanhtra.where(["thoi_gian > ? and thoi_gian < ?", date.to_time.utc, tomorrow.to_time.utc]).map {|l| LichViPhamSerializer.new( LichViPhamDecorator.new(l) )}
		render json: @lichs, :root => false
	end

	def remove
		@lich = LichTrinhGiangDay.find(params[:lich_id])
		authorize @lich, :thanhtra?
		if @lich.vi_pham			
			@vi_pham = @lich.vi_pham
		else
			@vi_pham = @lich.build_vi_pham
		end
		@vi_pham.remove! if @vi_pham.can_remove?		
		date = Date.strptime(params[:date], '%d/%m/%Y')
		tomorrow = date + 1.day
		@lichs = LichTrinhGiangDay.thanhtra.where(["thoi_gian > ? and thoi_gian < ?", date.to_time.utc, tomorrow.to_time.utc]).map {|l| LichViPhamSerializer.new( LichViPhamDecorator.new(l) )}
		render json: @lichs, :root => false
	end

	def confirm
		@lich = LichTrinhGiangDay.find(params[:lich_id])
		authorize @lich, :thanhtra?
		if @lich.vi_pham			
			@vi_pham = @lich.vi_pham
		else
			@vi_pham = @lich.build_vi_pham
		end
		@vi_pham.confirm! if @vi_pham.can_confirm?		
		date = Date.strptime(params[:date], '%d/%m/%Y')
		tomorrow = date + 1.day
		@lichs = LichTrinhGiangDay.thanhtra.where(["thoi_gian > ? and thoi_gian < ?", date.to_time.utc, tomorrow.to_time.utc]).map {|l| LichViPhamSerializer.new( LichViPhamDecorator.new(l) )}
		render json: @lichs, :root => false
	end

	def restore
		@lich = LichTrinhGiangDay.find(params[:lich_id])
		authorize @lich, :thanhtra?
		if @lich.vi_pham			
			@vi_pham = @lich.vi_pham
		else
			@vi_pham = @lich.build_vi_pham
		end
		@vi_pham.restore! if @vi_pham.can_restore?		
		date = Date.strptime(params[:date], '%d/%m/%Y')
		tomorrow = date + 1.day
		@lichs = LichTrinhGiangDay.thanhtra.where(["thoi_gian > ? and thoi_gian < ?", date.to_time.utc, tomorrow.to_time.utc]).map {|l| LichViPhamSerializer.new( LichViPhamDecorator.new(l) )}
		render json: @lichs, :root => false
	end
end