class AddDiplomaProjectIdToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :diploma_project_id, :integer
  end
end
