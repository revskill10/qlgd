class LichTrinhGiangDaysController < ApplicationController
	def info
		lich = LichTrinhGiangDay.find(params[:lich_id])
		render json: LichTrinhGiangDaySerializer.new(lich), :root => false
	end
	def index
		@lop = LopMonHoc.find(params[:lop_id])
		@lichs = @lop.lich_trinh_giang_days.with_giang_vien(params[:giang_vien_id]).bosung.map { |l| LopLichTrinhGiangDaySerializer.new(l)}
		render json: @lichs, :root => false
	end
	def create
		@lop = LopMonHoc.find(params[:lop_id])		
		hour = LichTrinhGiangDay::TIET2[params[:tiet_bat_dau].to_i][0].to_s
		minute = LichTrinhGiangDay::TIET2[params[:tiet_bat_dau].to_i][1].to_s
		thoi_gian = Time.strptime(hour + ":" + minute + " " +params[:thoi_gian], "%H:%M %d/%m/%Y")
		@lich = @lop.lich_trinh_giang_days.with_giang_vien(params[:giang_vien]).bosung.where(thoi_gian: thoi_gian).first
		if @lich.nil?	
			@lich = @lop.lich_trinh_giang_days.with_giang_vien(params[:giang_vien]).bosung.create(thoi_gian: thoi_gian,phong: params[:phong], so_tiet: params[:so_tiet].to_i, thuc_hanh: params[:thuc_hanh])			
		end
		@lichs = @lop.lich_trinh_giang_days.with_giang_vien(params[:giang_vien]).bosung.map { |l| LopLichTrinhGiangDaySerializer.new(l)}
		render json: @lichs, :root => false
	end
	def update
		@lop = LopMonHoc.find(params[:lop_id])		
		@lich = @lop.lich_trinh_giang_days.with_giang_vien(params[:giang_vien]).bosung.find(params[:id])
		if @lich
			hour = LichTrinhGiangDay::TIET2[params[:tiet_bat_dau].to_i][0].to_s
			minute = LichTrinhGiangDay::TIET2[params[:tiet_bat_dau].to_i][1].to_s
			thoi_gian = Time.strptime(hour + ":" + minute + " " +params[:thoi_gian], "%H:%M %d/%m/%Y")
			@lich.update_attributes(thoi_gian: thoi_gian, phong: params[:phong], so_tiet: params[:so_tiet].to_i, thuc_hanh: params[:thuc_hanh])
		end
		@lichs = @lop.lich_trinh_giang_days.with_giang_vien(params[:giang_vien]).bosung.map { |l| LopLichTrinhGiangDaySerializer.new(l)}
		render json: @lichs, :root => false
	end
	def remove
		@lop = LopMonHoc.find(params[:lop_id])		
		@lich = @lop.lich_trinh_giang_days.with_giang_vien(params[:giang_vien]).bosung.find(params[:id])
		if @lich and @lich.can_remove?
			@lich.remove!
		end
		@lichs = @lop.lich_trinh_giang_days.with_giang_vien(params[:giang_vien]).bosung.map { |l| LopLichTrinhGiangDaySerializer.new(l)}
		render json: @lichs, :root => false
	end
	def restore
		@lop = LopMonHoc.find(params[:lop_id])		
		@lich = @lop.lich_trinh_giang_days.with_giang_vien(params[:giang_vien]).bosung.find(params[:id])
		if @lich and @lich.can_restore?
			@lich.restore!
		end
		@lichs = @lop.lich_trinh_giang_days.with_giang_vien(params[:giang_vien]).bosung.map { |l| LopLichTrinhGiangDaySerializer.new(l)}
		render json: @lichs, :root => false
	end	
end