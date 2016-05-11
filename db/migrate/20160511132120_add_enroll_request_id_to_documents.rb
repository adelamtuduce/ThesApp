class AddEnrollRequestIdToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :enroll_request_id, :integer
  end
end
