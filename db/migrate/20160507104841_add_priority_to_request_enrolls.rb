class AddPriorityToRequestEnrolls < ActiveRecord::Migration
  def change
    add_column :enroll_requests, :priority, :integer
  end
end
