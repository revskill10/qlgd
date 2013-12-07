class StaticPagesController < ApplicationController
  def about
  end
  def home
  	respond_to do |format|
      if guest?
        format.html {render "static_pages/home/guest"} 
      elsif teacher?
        format.html {render "static_pages/home/teacher"}
      elsif student?
      	format.html {render "static_pages/home/student"}
      end
  	end
  end
end
