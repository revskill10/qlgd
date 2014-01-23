class Daotao::LopMonHocsController < TenantsController
	def index
		 #raise "not authorized" unless LopMonHocPolicy.new(current_user, LopMonHoc).daotao?		
		@lops = LopMonHoc.all.map {|lop| Daotao::LopMonHocSerializer.new(lop)}
		@t = @lops.map {|lop| {:id => lop.id, :text => lop.text}}
		render json: {count: @lops.count, lops: @lops, t: @t}
	end

	def create
		raise "not authorized" unless LopMonHocPolicy.new(current_user, LopMonHoc).daotao?		
		@lop = LopMonHoc.where(ma_lop: params[:ma_lop].strip.upcase, ma_mon_hoc: params[:ma_mon_hoc]).first
		unless @lop
			@lop = LopMonHoc.create!(ma_lop: params[:ma_lop].strip.upcase, ma_mon_hoc: params[:ma_mon_hoc], ten_mon_hoc: params[:ten_mon_hoc])			
		end
		@assistant = @lop.assistants.where(giang_vien_id: params[:giang_vien_id]).first_or_create!
		render json: {"result" => "OK"}
	end
	def start
		raise "not authorized" unless LopMonHocPolicy.new(current_user, LopMonHoc).daotao?		
		@lop = LopMonHoc.find(params[:id])
		authorize @lop, :daotao?
		@lop.start! if @lop.can_start?
		@lops = LopMonHoc.all.map {|lop| Daotao::LopMonHocSerializer.new(lop)}
		@t = @lops.map {|lop| {:id => lop.id, :text => lop.text}}
		render json: {count: @lops.count, lops: @lops, t: @t}
	end
	def restore
		raise "not authorized" unless LopMonHocPolicy.new(current_user, LopMonHoc).daotao?		
		@lop = LopMonHoc.find(params[:id])
		authorize @lop, :daotao?
		@lop.restore! if @lop.can_restore?
		@lops = LopMonHoc.all.map {|lop| Daotao::LopMonHocSerializer.new(lop)}
		@t = @lops.map {|lop| {:id => lop.id, :text => lop.text}}
		render json: {count: @lops.count, lops: @lops, t: @t}
	end
	def remove
		raise "not authorized" unless LopMonHocPolicy.new(current_user, LopMonHoc).daotao?		
		@lop = LopMonHoc.find(params[:id])
		authorize @lop, :daotao?
		@lop.remove! if @lop.can_remove?
		@lops = LopMonHoc.all.map {|lop| Daotao::LopMonHocSerializer.new(lop)}
		@t = @lops.map {|lop| {:id => lop.id, :text => lop.text}}
		render json: {count: @lops.count, lops: @lops, t: @t}
	end
	def update
		raise "not authorized" unless LopMonHocPolicy.new(current_user, LopMonHoc).daotao?		
		@lop = LopMonHoc.find(params[:id])
		authorize @lop, :daotao?
		@lop.update_attributes(ma_lop: params[:ma_lop])
		@lops = LopMonHoc.all.map {|lop| Daotao::LopMonHocSerializer.new(lop)}
		@t = @lops.map {|lop| {:id => lop.id, :text => lop.text}}
		render json: {count: @lops.count, lops: @lops, t: @t}
	end
end