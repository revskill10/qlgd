
class ApplicationController < ActionController::Base
  has_mobile_fu
  protect_from_forgery  
  include Pundit
  
  
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  
  def routing
   render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
  end
  

  around_filter :select_shard

  def select_shard(&block)
    if params[:tenant_id].present?
      tenant = Tenant.find(params[:tenant_id]) || Tenant.last
      if tenant
        Octopus.using(tenant.database, &block)  
      else
        yield
      end
    else
      tenant = Tenant.last
      if tenant      
        Octopus.using(tenant.database, &block)
      else
        yield
      end
    end
  end

  def current_tenant
    if params[:tenant_id].present?
      tenant = Tenant.find(params[:tenant_id])
    else
      Tenant.last
    end
  end
  helper_method :current_tenant
  
  def user_not_authorized
    flash[:error] = "You are not authorized to perform this action."
    redirect_to request.headers["Referer"] || "/"
  end
end
