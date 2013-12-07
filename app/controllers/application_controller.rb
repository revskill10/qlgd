class ApplicationController < ActionController::Base
  protect_from_forgery  
  private
  def guest?
  	(current_user.nil?) or (current_user and !user_signed_in?)
  end
  def teacher?
  	current_user and current_user.imageable.is_a?(GiangVien)
  end  
  def student?
  	current_user and current_user.imageable.is_a?(SinhVien)
  end
end
