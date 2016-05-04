class AddDescriptionToDiplomaProjects < ActiveRecord::Migration
  def change
    add_column :diploma_projects, :description, :text
  end
end
