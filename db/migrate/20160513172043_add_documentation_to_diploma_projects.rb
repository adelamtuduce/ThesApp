class AddDocumentationToDiplomaProjects < ActiveRecord::Migration
   def up
    add_attachment :diploma_projects, :documentation
  end

  def down
    remove_attachment :diploma_projects, :documentation
  end
end
