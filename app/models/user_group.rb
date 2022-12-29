class UserGroup < ActiveRecord::Base
  attr_accessible :group_id, :user_id

  validates :group_id, :user_id, :presence => true

  belongs_to :group
  belongs_to :user
end
