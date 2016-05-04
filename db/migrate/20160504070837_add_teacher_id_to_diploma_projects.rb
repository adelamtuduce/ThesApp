class AddTeacherIdToDiplomaProjects < ActiveRecord::Migration
  def change
    add_column :diploma_projects, :teacher_id, :integer
  end
end
