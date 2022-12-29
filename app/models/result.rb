class Result < ActiveRecord::Base
  attr_accessible :data, :du_gio_id, :question_id
  
  belongs_to :question  
  belongs_to :du_gio
  
  validates :du_gio_id, :question_id, :presence => true
end
