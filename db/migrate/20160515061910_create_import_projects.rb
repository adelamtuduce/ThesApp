class CreateImportProjects < ActiveRecord::Migration
  def change
    create_table :import_projects do |t|
      t.integer :teacher_id
      t.string :status, default: false

      t.timestamps
    end
  end
end
