class DashboardController < ApplicationController
  
  def index    
  	respond_to do |format|
      if guest?
        format.html {render "dashboard/index/guest"} 
      elsif teacher?
        @dslops = current_image.lop_mon_hocs
        format.html {render "dashboard/index/teacher"}
      elsif student?
      	format.html {render "dashboard/index/student"}
      end
  	end
  end

  

end
