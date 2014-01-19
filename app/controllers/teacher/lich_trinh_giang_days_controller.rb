class Teacher::LichTrinhGiangDaysController < TenantsController

	before_filter :get_lop, :except => [:info, :thanhtra, :thanhtraupdate, :accept, :request2, :home, :monitor, :index, :index_bosung]

	
	def info
		lich = LichTrinhGiangDay.find(params[:lich_id])
		render json: LichTrinhGiangDaySerializer.new(lich.decorate), :root => false
	end
	def home
		@lichs = current_user.get_lichs
		if @lichs.count > 0
			@lichs2 = @lichs.map{|k| LichTrinhGiangDaySerializer.new(LichTrinhGiangDayDecorator.new(k))}.group_by {|g| g.tuan}
			@t = @lichs2.keys.inject([]) {|res, elem| res << {:tuan => TuanSerializer.new(Tuan.where(stt: elem).first.decorate), :colapse => "tuan#{elem}" , :active => (Tuan.active.first.try(:stt) == elem), :data => @lichs2[elem]}}		
		end
		render json: @t, :root => false
	end
	def thanhtra						
		@lichs = current_user.get_lichs.select {|l| l.reported? or l.confirmed? or l.accepted? or l.requested? }
		if @lichs.count > 0
			@lichs2 = @lichs.map {|l| LichViPhamSerializer.new( LichViPhamDecorator.new(l) )}		
		else
			@lichs2 = []
		end
		render json: @lichs2, :root => false	
	end
	def thanhtraupdate
		@lich = LichTrinhGiangDay.find(params[:lich_id])
		authorize @lich, :update?
		if @lich.vi_pham			
			@vi_pham = @lich.vi_pham
			@vi_pham.note2 = params[:note2] 			
			@vi_pham.save!
		else
			@vi_pham = @lich.build_vi_pham(note2: params[:note2])			
			@vi_pham.save!
		end
		@lichs = current_user.get_lichs.select {|l| l.reported? or l.confirmed? or l.accepted? or l.requested? }
		if @lichs.count > 0
			@lichs2 = @lichs.map {|l| LichViPhamSerializer.new( LichViPhamDecorator.new(l) )}		
		else
			@lichs2 = []
		end
		render json: @lichs2, :root => false	
	end
	def accept
		@lich = LichTrinhGiangDay.find(params[:lich_id])
		authorize @lich, :update?
		if @lich.vi_pham			
			@vi_pham = @lich.vi_pham
			@vi_pham.accept! if @vi_pham.can_accept?
			@vi_pham.save!
		else
			@vi_pham = @lich.build_vi_pham
			@vi_pham.accept! if @vi_pham.can_accept?
			@vi_pham.save!
		end
		@lichs = current_user.get_lichs.select {|l| l.reported? or l.confirmed? or l.accepted? or l.requested? }
		if @lichs.count > 0
			@lichs2 = @lichs.map {|l| LichViPhamSerializer.new( LichViPhamDecorator.new(l) )}		
		else
			@lichs2 = []
		end
		render json: @lichs2, :root => false	
	end
	def accept
		@lich = LichTrinhGiangDay.find(params[:lich_id])
		authorize @lich, :update?
		if @lich.vi_pham			
			@vi_pham = @lich.vi_pham
			@vi_pham.accept! if @vi_pham.can_accept?
			@vi_pham.save!
		else
			@vi_pham = @lich.build_vi_pham
			@vi_pham.accept! if @vi_pham.can_accept?
			@vi_pham.save!
		end
		@lichs = current_user.get_lichs.select {|l| l.reported? or l.confirmed? or l.accepted? or l.requested? }
		if @lichs.count > 0
			@lichs2 = @lichs.map {|l| LichViPhamSerializer.new( LichViPhamDecorator.new(l) )}		
		else
			@lichs2 = []
		end
		render json: @lichs2, :root => false	
	end
	def request2
		@lich = LichTrinhGiangDay.find(params[:lich_id])
		authorize @lich, :update?
		if @lich.vi_pham			
			@vi_pham = @lich.vi_pham
			@vi_pham.request! if @vi_pham.can_request?
			@vi_pham.save!
		else
			@vi_pham = @lich.build_vi_pham
			@vi_pham.request! if @vi_pham.can_request?
			@vi_pham.save!
		end
		@lichs = current_user.get_lichs.select {|l| l.reported? or l.confirmed? or l.accepted? or l.requested? }
		if @lichs.count > 0
			@lichs2 = @lichs.map {|l| LichViPhamSerializer.new( LichViPhamDecorator.new(l) )}		
		else
			@lichs2 = []
		end
		render json: @lichs2, :root => false	
	end
	def monitor		
		@lichs = LichTrinhGiangDay.active.map{|k| LichTrinhGiangDaySerializer.new(LichTrinhGiangDayDecorator.new(k))}
		render json: @lichs, :root => false		
	end

	def index
		@lop = LopMonHoc.find(params[:lop_id])
		@lichs = policy_scope(@lop.lich_trinh_giang_days).map { |l| LopLichTrinhGiangDaySerializer.new(l)}
		render json: @lichs, :root => false
	end
	def index_bosung
		@lop = LopMonHoc.find(params[:lop_id])
		@lichs = policy_scope(@lop.lich_trinh_giang_days.bosung).map { |l| LopLichTrinhGiangDaySerializer.new(l)}
		render json: @lichs, :root => false
	end
	def create_bosung			
		hour = LichTrinhGiangDay::TIET2[params[:tiet_bat_dau].to_i][0].to_s
		minute = LichTrinhGiangDay::TIET2[params[:tiet_bat_dau].to_i][1].to_s
		thoi_gian = Time.strptime(hour + ":" + minute + " " +params[:thoi_gian], "%H:%M %d/%m/%Y")
		if giang_vien
			@lich = lop.lich_trinh_giang_days.with_giang_vien(giang_vien.id).bosung.where(thoi_gian: thoi_gian).first		
			if @lich.nil?	
				@lich = lop.lich_trinh_giang_days.with_giang_vien(giang_vien.id).bosung.create(thoi_gian: thoi_gian,phong: params[:phong], so_tiet: params[:so_tiet].to_i, ltype: params[:ltype])			
			end
			@lichs = lop.lich_trinh_giang_days.with_giang_vien(giang_vien.id).bosung.map { |l| LopLichTrinhGiangDaySerializer.new(l)}
			render json: @lichs, :root => false
		else
			render json: {:error => "No teacher here"}
		end
	end
	def update_bosung		
		if giang_vien
			@lich = lop.lich_trinh_giang_days.with_giang_vien(giang_vien.id).bosung.find(params[:id])
			authorize @lich, :update?
			if @lich
				hour = LichTrinhGiangDay::TIET2[params[:tiet_bat_dau].to_i][0].to_s
				minute = LichTrinhGiangDay::TIET2[params[:tiet_bat_dau].to_i][1].to_s
				thoi_gian = Time.strptime(hour + ":" + minute + " " +params[:thoi_gian], "%H:%M %d/%m/%Y")
				@lich.update_attributes(thoi_gian: thoi_gian, phong: params[:phong], so_tiet: params[:so_tiet].to_i, ltype: params[:ltype])
			end
			@lichs = lop.lich_trinh_giang_days.with_giang_vien(giang_vien.id).bosung.map { |l| LopLichTrinhGiangDaySerializer.new(l)}
			render json: @lichs, :root => false
		else
			render json: {:error => "No teacher here"}
		end
	end
	def remove_bosung		
		if giang_vien
			@lich = lop.lich_trinh_giang_days.with_giang_vien(giang_vien.id).bosung.find(params[:id])
			authorize @lich, :update?
			if @lich and @lich.can_remove?
				@lich.remove!
			end
			@lichs = lop.lich_trinh_giang_days.with_giang_vien(giang_vien.id).bosung.map { |l| LopLichTrinhGiangDaySerializer.new(l)}
			render json: @lichs, :root => false
		else
			render json: {:error => "No teacher here"}
		end
	end
	def restore_bosung	
		@lich = lop.lich_trinh_giang_days.bosung.find(params[:id])
		authorize @lich, :update?
		if @lich and @lich.can_restore?
			@lich.restore!
		end
		if giang_vien
			@lichs = lop.lich_trinh_giang_days.with_giang_vien(giang_vien.id).map { |l| LopLichTrinhGiangDaySerializer.new(l)}
		else
			@lichs = lop.lich_trinh_giang_days.map { |l| LopLichTrinhGiangDaySerializer.new(l)}
		end
		render json: @lichs, :root => false
	end	
	def nghiday		
		@lich = lop.lich_trinh_giang_days.find(params[:id])
		authorize @lich, :update?
		if @lich and @lich.can_nghiday?
			@lich.note = params[:note]
			@lich.nghiday!
			@lich.save!
		end
		if giang_vien
			@lichs = lop.lich_trinh_giang_days.with_giang_vien(giang_vien.id).map { |l| LopLichTrinhGiangDaySerializer.new(l)}
		else
			@lichs = lop.lich_trinh_giang_days.map { |l| LopLichTrinhGiangDaySerializer.new(l)}
		end
		render json: @lichs, :root => false
	end
	def unnghiday		
		@lich = lop.lich_trinh_giang_days.find(params[:id])		
		authorize @lich, :update?
		if @lich and @lich.can_unnghiday?
			@lich.unnghiday!
			@lich.save!
		end
		if giang_vien
			@lichs = lop.lich_trinh_giang_days.with_giang_vien(giang_vien.id).map { |l| LopLichTrinhGiangDaySerializer.new(l)}
		else
			@lichs = lop.lich_trinh_giang_days.map { |l| LopLichTrinhGiangDaySerializer.new(l)}
		end
		render json: @lichs, :root => false
	end
	def complete		
		@lich = lop.lich_trinh_giang_days.find(params[:id])
		authorize @lich, :update?
		if @lich and @lich.can_complete?
			@lich.complete!
		end
		enrollments = @lich.lop_mon_hoc.enrollments    
      	results = enrollments.map {|en| LichEnrollmentDecorator.new(en,@lich) }.map {|e| LichEnrollmentSerializer.new(e)}
      	render json: {info: {lop: LopMonHocSerializer.new(@lich.lop_mon_hoc),  lich: LichTrinhGiangDaySerializer.new(@lich.decorate)}, enrollments: results}.to_json
	end
	def uncomplete		
		@lich = lop.lich_trinh_giang_days.find(params[:id])
		authorize @lich, :update?
		if @lich and @lich.can_uncomplete?
			@lich.uncomplete!
		end
		if giang_vien
			@lichs = lop.lich_trinh_giang_days.with_giang_vien(giang_vien.id).map { |l| LopLichTrinhGiangDaySerializer.new(l)}
		else
			@lichs = lop.lich_trinh_giang_days.map { |l| LopLichTrinhGiangDaySerializer.new(l)}
		end
		render json: @lichs, :root => false
	end	
	def remove	
		@lich = lop.lich_trinh_giang_days.find(params[:id])
		authorize @lich, :update?
		if @lich and @lich.can_remove?
			@lich.remove!
		end
		if giang_vien
			@lichs = lop.lich_trinh_giang_days.with_giang_vien(giang_vien.id).map { |l| LopLichTrinhGiangDaySerializer.new(l)}
		else
			@lichs = lop.lich_trinh_giang_days.map { |l| LopLichTrinhGiangDaySerializer.new(l)}
		end
		render json: @lichs, :root => false
	end
	def restore	
		@lich = lop.lich_trinh_giang_days.find(params[:id])
		authorize @lich, :update?
		if @lich and @lich.can_restore?
			@lich.restore!
		end
		if giang_vien
			@lichs = lop.lich_trinh_giang_days.with_giang_vien(giang_vien.id).map { |l| LopLichTrinhGiangDaySerializer.new(l)}
		else
			@lichs = lop.lich_trinh_giang_days.map { |l| LopLichTrinhGiangDaySerializer.new(l)}
		end
		render json: @lichs, :root => false
	end
	def update		
		@lich = lop.lich_trinh_giang_days.find(params[:id])
		authorize @lich, :update_thongso?
		if @lich
			@lich.update_attributes(phong: params[:phong], so_tiet: params[:so_tiet].to_i, ltype: params[:ltype], note: params[:note])
		end
		if giang_vien
			@lichs = lop.lich_trinh_giang_days.with_giang_vien(giang_vien.id).map { |l| LopLichTrinhGiangDaySerializer.new(l)}
		else
			@lichs = lop.lich_trinh_giang_days.map { |l| LopLichTrinhGiangDaySerializer.new(l)}
		end
		render json: @lichs, :root => false
	end

	def capnhat
		# update in lich context		
		@lich = lop.lich_trinh_giang_days.find(params[:id])
		authorize @lich, :update?
		if @lich
			@lich.update_attributes(phong: params[:phong], so_tiet: params[:so_tiet].to_i, ltype: params[:ltype])
		end
		enrollments = @lich.lop_mon_hoc.enrollments    
      	results = enrollments.map {|en| LichEnrollmentDecorator.new(en,@lich) }.map {|e| LichEnrollmentSerializer.new(e)}
      	render json: {info: {lop: LopMonHocSerializer.new(@lich.lop_mon_hoc),  lich: LichTrinhGiangDaySerializer.new(@lich.decorate)}, enrollments: results}.to_json
	end
	def getcontent		
		if giang_vien
			@lichs = lop.lich_trinh_giang_days.normal_or_bosung.accepted.with_giang_vien(giang_vien.id).map { |l| LichTrinhGiangDaySerializer.new(l.decorate)}
		else
			@lichs = lop.lich_trinh_giang_days.normal_or_bosung.accepted.map { |l| LichTrinhGiangDaySerializer.new(l.decorate)}
		end
		render json: @lichs, :root => false
	end
	def content		
		if giang_vien
			@lich = lop.lich_trinh_giang_days.with_giang_vien(giang_vien.id).find(params[:id])
			authorize @lich, :update?
			if @lich 
				@lich.update_attributes(noi_dung: params[:content])
			end
			@lichs = lop.lich_trinh_giang_days.normal_or_bosung.accepted.with_giang_vien(giang_vien.id).map { |l| LichTrinhGiangDaySerializer.new(l.decorate)}
		else
			@lich = lop.lich_trinh_giang_days.find(params[:id])
			authorize @lich, :update?
			if @lich 
				@lich.update_attributes(noi_dung: params[:content])
			end
			@lichs = lop.lich_trinh_giang_days.normal_or_bosung.accepted.map { |l| LichTrinhGiangDaySerializer.new(l.decorate)}
		end
		render json: @lichs, :root => false
	end

	protected

	def get_lop
		@lop = LopMonHoc.find(params[:lop_id])	
		authorize @lop, :update?
		@giang_vien = current_user.giang_vien(@lop)	
	end
	def giang_vien
		@giang_vien
	end
	def lop
		@lop
	end
end