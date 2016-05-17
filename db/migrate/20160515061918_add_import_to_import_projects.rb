class AddImportToImportProjects < ActiveRecord::Migration
   def up
    add_attachment :import_projects, :import
  end

  def down
    remove_attachment :import_projects, :import
  end
end
