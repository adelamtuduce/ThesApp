class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.integer :diploma_project_id
      t.integer :user_id
      t.timestamps
    end
  end
end
