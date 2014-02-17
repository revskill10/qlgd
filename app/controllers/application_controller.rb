
class ApplicationController < ActionController::Base
  has_mobile_fu
  protect_from_forgery  
  include Pundit
  before_filter :current_tenant
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  
  def routing
   render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
  end
  

  private
  def current_tenant
    Apartment::Database.switch('public')

    if params[:tenant_id].present?
      tenant = Tenant.find(params[:tenant_id])
      Apartment::Database.switch(tenant.name)
      return tenant
    else
      tenant = Tenant.last
      Apartment::Database.switch(tenant.name)
      return tenant
    end
  end
  def user_not_authorized
    flash[:error] = "You are not authorized to perform this action."
    redirect_to request.headers["Referer"] || "/"
  end
end
