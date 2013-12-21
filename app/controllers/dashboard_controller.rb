class DashboardController < ApplicationController
  
  def index    
  	respond_to do |format|
      if guest?
        @x = "Hello world"
        format.html {render "dashboard/index/guest"} 
      elsif teacher?        
        @lichs = current_image.lich_trinh_giang_days
        format.html {render "dashboard/index/teacher"}
      elsif student?
        
      	format.html {render "dashboard/index/student"}
      end
  	end
  end

  

end
