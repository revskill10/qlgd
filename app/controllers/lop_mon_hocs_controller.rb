class LopMonHocsController < ApplicationController
	def info
		lop = LopMonHoc.find(params[:lop_id])
		render json: LopMonHocSerializer.new(lop), :root => false
	end
	def update

	end
end