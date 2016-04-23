class AddDownloadUrlToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :download_url, :string
  end
end
