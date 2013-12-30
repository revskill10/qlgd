class Submission < ActiveRecord::Base
  attr_accessible :assignment_id, :grade, :sinh_vien_id, :giang_vien_id

  belongs_to :assignment
  belongs_to :sinh_vien

  has_many :submissions, :through => :sinh_vien
  validates :assignment_id, :sinh_vien_id, :giang_vien_id, :presence => true

end
