class AddEnrollmentIdToSubmission < ActiveRecord::Migration
  def change
    add_column :submissions, :enrollment_id, :integer
  end
end
