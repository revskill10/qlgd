class Question < ActiveRecord::Base
  attr_accessible :data, :name, :survey_id

  belongs_to :survey

  has_many :du_gios, :dependent => :destroy
end
