class AddFileToDocuments < ActiveRecord::Migration
  def up
    add_attachment :documents, :file
  end

  def down
    remove_attachment  :documents, :file
  end
end
