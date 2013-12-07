class LopMonHoc < ActiveRecord::Base
  serialize :settings, ActiveRecord::Coders::Hstore
  attr_accessible :ma_giang_vien, :ma_lop, :ma_mon_hoc
  hstore_accessor :settings, :language


  validates :ma_lop, :ma_giang_vien, :ma_mon_hoc, :presence => true

  state_machine :state, :initial => :pending do
    event :start do
      transition :pending => :started
    end
    event :complete do 
      transition :started => :completed
    end
  end
end
