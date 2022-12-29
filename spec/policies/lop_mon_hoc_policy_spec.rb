require 'spec_helper'

describe LopMonHocPolicy do 

	describe "As a teacher" do 

		it "can update settings, assignments and grades" do 
			t1 = FactoryGirl.create(:tuan, :stt => 1, :tu_ngay => Date.new(2013, 8, 12).change(:offset => Rational(7,24)), :den_ngay => Date.new(2013, 8, 18).change(:offset => Rational(7,24)))
		    t2 = FactoryGirl.create(:tuan, :stt => 2,  :tu_ngay => Date.new(2013, 8, 19).change(:offset => Rational(7,24)), :den_ngay => Date.new(2013, 8, 25).change(:offset => Rational(7,24)))
		    t3 = FactoryGirl.create(:tuan, :stt => 3,  :tu_ngay => Date.new(2013, 8, 26).change(:offset => Rational(7,24)), :den_ngay => Date.new(2013, 8, 31).change(:offset => Rational(7,24)))
		    lop = FactoryGirl.create(:lop_mon_hoc)
		    gv = FactoryGirl.create(:giang_vien)
		    calendar = FactoryGirl.create(:calendar, :lop_mon_hoc => lop, :giang_vien => gv)        			
			u = FactoryGirl.create(:user, :imageable => gv)				
			Pundit.policy!(u, lop.reload).update?.should be_true

		end

	end
end