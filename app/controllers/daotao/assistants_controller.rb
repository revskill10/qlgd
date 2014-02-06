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
		@lop.assistants.where(giang_vien_id: params[:giang_vien_id]).first_or_create!		
		@assistants = @lop.assistants.map {|as| Daotao::AssistantSerializer.new(as)}
		render json: @assistants, :root => false
	end

	def update
		@lop = LopMonHoc.find(params[:lop_id])
		authorize @lop, :daotao?
		@assistant = @lop.assistants.find(params[:id])	
		@assistant.update_attributes(username: params[:username])
		@assistants = @lop.assistants.map {|as| Daotao::AssistantSerializer.new(as)}
		render json: @assistants, :root => false
	end
end