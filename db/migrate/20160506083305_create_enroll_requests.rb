class CreateEnrollRequests < ActiveRecord::Migration
  def change
    create_table :enroll_requests do |t|
      t.integer :student_id
      t.integer :teacher_id
      t.integer :diploma_project_id
      t.boolean :accepted

      t.timestamps
    end
  end
end
