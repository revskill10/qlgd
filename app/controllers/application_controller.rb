
class ApplicationController < ActionController::Base
  protect_from_forgery  
  include Pundit
  before_filter :load_tenant
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  

  

  private
  def load_tenant
  	Apartment::Database.switch(Tenant.last.name)
  end
  def user_not_authorized
    flash[:error] = "You are not authorized to perform this action."
    redirect_to request.headers["Referer"] || "/"
  end
end
