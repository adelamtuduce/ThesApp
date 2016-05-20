class CreateStudentEvents < ActiveRecord::Migration
  def change
    create_table :student_events do |t|
      t.integer :student_id
      t.integer :event_id

      t.timestamps
    end
  end
end
