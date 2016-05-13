class AddSentToEnrollRequests < ActiveRecord::Migration
  def change
    add_column :enroll_requests, :sent, :boolean, default: false
  end
end
