class CreateDiplomaProjects < ActiveRecord::Migration
  def change
    create_table :diploma_projects do |t|
      t.string :name
      t.integer :students
      t.integer :duration

      t.timestamps
    end
  end
end
