class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.datetime :start_at
      t.datetime :end_at
      t.string :allDay
      t.integer :student_id
      t.integer :teacher_id

      t.timestamps
    end
  end
end
