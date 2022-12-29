class Daotao::UsersController < TenantsController
	def index
		@users = User.all.map {|u| {:id => u.id, :text => u.username}}
		render json: @users, :root => false
	end
end