require 'spec_helper'

describe LichTrinhGiangDayPolicy do 
	describe "As a teacher" do 

		it "can complete a lich" do 
			t1 = FactoryGirl.create(:tuan)
    		t2 = FactoryGirl.create(:tuan, :tu_ngay => Date.new(2013, 8, 19).change(:offset => Rational(7,24)), :den_ngay => Date.new(2013, 8, 25).change(:offset => Rational(7,24)))
			gv = FactoryGirl.create(:giang_vien)
			u = FactoryGirl.create(:user, :imageable => gv)
			lop = FactoryGirl.create(:lop_mon_hoc)    
    		lich = lop.lich_trinh_giang_days.with_giang_vien(gv.id).normal.create(:so_tiet => 2, :thoi_gian => Time.new(2013, 8, 12, 6, 30))
    		Timecop.freeze(lich.thoi_gian.localtime + 1.day)
			lich.accept!
			lich.accepted?.should be_true			
			Pundit.policy!(u, lich).update?.should be_false
			lop.start!(gv)
			lop.assignments.count.should > 0
			lop.settings.should_not be_nil
			lop.settings[:so_tiet_ly_thuyet] = 30
			lop.settings[:so_tiet_thuc_hanh] = 0
			lop.save!		
			lop.tong_so_tiet.should > 0
			Pundit.policy!(u, lich.reload).update?.should be_true
		end
	end
end