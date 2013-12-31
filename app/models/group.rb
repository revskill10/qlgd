class Group < ActiveRecord::Base
  attr_accessible :description, :name

  validates :name, :presence => true
  has_many :user_groups, :dependent => :destroy
  has_many :users, :through => :user_groups
end
