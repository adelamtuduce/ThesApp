class RenameStudentsProject < ActiveRecord::Migration
  def self.up
    rename_column :diploma_projects, :students, :max_students
  end

  def self.down
    rename_column :diploma_projects, :max_students, :students
  end
end
