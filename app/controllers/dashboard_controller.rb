class DashboardController < ApplicationController

  def index
  	respond_to do |format|
      if guest?
        format.html {render "dashboard/index/guest"} 
      elsif teacher?
        format.html {render "dashboard/index/teacher"}
      elsif student?
      	format.html {render "dashboard/index/student"}
      end
  	end
  end
end
