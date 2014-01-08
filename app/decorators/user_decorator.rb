#encoding: utf-8
class UserDecorator < Draper::Decorator
	delegate_all


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
		object.groups.pluck(:name).include?("superadmin")
	end

	def is_admin?
		object.groups.pluck(:name).include?("admin")
	end

	def is_dao_tao?
		object.groups.pluck(:name).include?("dao_tao")
	end

	def is_quan_ly_sinh_vien?
		object.groups.pluck(:name).include?("quan_ly_sinh_vien")
	end

	def is_thanh_tra?
		object.groups.pluck(:name).include?("thanh_tra")
	end

	def is_kiem_dinh?
		object.groups.pluck(:name).include?("kiem_dinh")
	end
end