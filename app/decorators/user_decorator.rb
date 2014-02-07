#encoding: utf-8
class UserDecorator < Draper::Decorator
	delegate_all

	def initialize(user)
		@user = User.where(id: user.id).includes(:groups).first
	end
	def object
		@user
	end
	def is_giang_vien?
		object.imageable and object.imageable.is_a?(GiangVien)
	end

	def is_sinh_vien?
		object.imageable and object.imageable.is_a?(SinhVien)
	end

	def is_assistant?
		object.assistants.count > 0
	end

	def is_super_admin?
		object.groups.pluck(:name).include?("superadmin") or object.username == 'dungth@hpu.edu.vn'
	end

	def is_admin?
		is_super_admin? or object.groups.pluck(:name).include?("admin")
	end

	def is_dao_tao?
		is_admin? or object.groups.pluck(:name).include?("dao_tao")
	end

	def is_dao_tao_duyet?
		is_admin? or is_dao_tao? or object.groups.pluck(:name).include?("dao_tao_duyet")
	end

	def is_quan_ly_sinh_vien?
		is_admin? or object.groups.pluck(:name).include?("quan_ly_sinh_vien")
	end

	def is_thanh_tra?
		is_admin? or object.groups.pluck(:name).include?("thanh_tra")
	end

	def is_kiem_dinh?
		is_admin? or object.groups.pluck(:name).include?("kiem_dinh")
	end
end