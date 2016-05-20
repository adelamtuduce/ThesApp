class RemoveStudentIdFromEvents < ActiveRecord::Migration
  def up
  	remove_column :events, :student_id
  end

  def down
  	add_column :events, :student_id, :integer
  end
end
