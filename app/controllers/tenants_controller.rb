class TenantsController < ApplicationController
	

	
  include Pundit
    

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
	
end