class AssignmentGroup < ActiveRecord::Base  
  attr_accessible :lop_mon_hoc_id, :name, :state, :weight, :giang_vien_id

  belongs_to :lop_mon_hoc
  belongs_to :giang_vien
  has_many :assignments, :dependent => :destroy, :order => "position, updated_at"
  acts_as_list scope: :lop_mon_hoc

  validates :name, :weight, :giang_vien_id, :presence => true
  validates :lop_mon_hoc, :presence => true
  validates :giang_vien, :presence => true
  validates :weight, numericality: {only_integer: true, less_than_or_equal_to: 100, greater_than_or_equal_to: 0}
  
  def can_destroy?
  	return true if assignments.count == 0
  	return false if assignments.select {|a| a.can_destroy? == false}.count > 0
    return true
  end

  def diem_trung_binh(sinh_vien_id)
    return 0 if assignments.count == 0
    sum = assignments.to_a.sum { |a| (a.submissions.where(sinh_vien_id: sinh_vien_id).first.try(:grade) || 0.0 ) * (weight / 10.0) / (a.try(:points) || 1) / assignments.count }    
    sum.round(0).to_i    
  end
end
