require 'pg_tools'
class ApplicationController < ActionController::Base
  protect_from_forgery  
  #before_filter :load_tenant
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
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

  
  def current_image
    current_user.imageable
  end
  def current_tenant
    @current_tenant ||= Tenant.last
    @current_tenant
  end
  def load_tenant
    PgTools.set_search_path current_tenant.name, false
  end
  helper_method :current_image

  private

  def user_not_authorized
    flash[:error] = "You are not authorized to perform this action."
    redirect_to request.headers["Referer"] || root_path
  end
end
