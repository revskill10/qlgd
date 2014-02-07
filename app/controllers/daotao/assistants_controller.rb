class Daotao::AssistantsController < TenantsController
	def index
		@lop = LopMonHoc.find(params[:lop_id])
		authorize @lop, :daotao?
		@assistants = @lop.assistants.map {|as| Daotao::AssistantSerializer.new(as)}
		render json: @assistants, :root => false
	end

	def delete
		@lop = LopMonHoc.find(params[:lop_id])
		authorize @lop, :daotao?
		@assistant = @lop.assistants.find(params[:id])		
		@assistant.destroy		
		@assistants = @lop.assistants.map {|as| Daotao::AssistantSerializer.new(as)}
		render json: @assistants, :root => false
	end

	def create
		@lop = LopMonHoc.find(params[:lop_id])
		authorize @lop, :daotao?
		@giang_vien = GiangVien.find(params[:giang_vien_id])
		#@user = @giang_vien.user
		@assistant = @lop.assistants.create(giang_vien_id: @giang_vien.id)
		#@assistant.update_attributes(user_id: @user.id) if @user
		@assistants = @lop.assistants.map {|as| Daotao::AssistantSerializer.new(as)}
		render json: @assistants, :root => false
	end

	def update
		@lop = LopMonHoc.find(params[:lop_id])
		authorize @lop, :daotao?
		@assistant = @lop.assistants.find(params[:id])	
		@user = User.where(username: params[:username]).first
		@assistant.update_attributes(user_id: @user.id)
		@assistants = @lop.assistants.map {|as| Daotao::AssistantSerializer.new(as)}
		render json: @assistants, :root => false
	end
end