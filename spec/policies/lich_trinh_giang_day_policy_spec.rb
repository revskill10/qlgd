require 'spec_helper'

describe LichTrinhGiangDayPolicy do 
	describe "As a teacher" do 

		it "can complete a lich" do 
			t1 = FactoryGirl.create(:tuan)
    		t2 = FactoryGirl.create(:tuan, :tu_ngay => Date.new(2013, 8, 19).change(:offset => Rational(7,24)), :den_ngay => Date.new(2013, 8, 25).change(:offset => Rational(7,24)))
			gv = FactoryGirl.create(:giang_vien)
			u = FactoryGirl.create(:user, :imageable => gv)
			lop = FactoryGirl.create(:lop_mon_hoc)    
    		lich = lop.lich_trinh_giang_days.create(:so_tiet => 2, :thoi_gian => DateTime.new(2013, 8, 12, 6, 30), :giang_vien_id => gv.id)
    		Timecop.freeze(lich.thoi_gian.localtime + 1.day)
			lich.accept!
			lich.accepted?.should be_true			
			lich.lop_mon_hoc.pending?.should be_true
			Pundit.policy!(u, lich).update?.should be_false
			lop.settings = {}
			lop.start!			
			Pundit.policy!(u, lich.reload).update?.should be_true
		end
	end
end