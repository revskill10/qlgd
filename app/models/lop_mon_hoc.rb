class LopMonHoc < ActiveRecord::Base
  serialize :settings
  attr_accessible :ma_lop, :ma_mon_hoc
  hstore_accessor :settings, :language


  validates :ma_lop, :ma_mon_hoc, :presence => true
  belongs_to :giang_vien
  has_many :calendars, :dependent => :destroy

  state_machine :state, :initial => :pending do
    event :start do
      transition :pending => :started
    end
    before_transition :on => :start, :do => :create_lichs
    event :complete do 
      transition :started => :completed
    end
  end

  private
  def create_lichs
    
  end
end
