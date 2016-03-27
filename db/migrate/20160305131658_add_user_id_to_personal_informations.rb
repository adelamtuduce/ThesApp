class AddUserIdToPersonalInformations < ActiveRecord::Migration
  def change
    add_column :personal_informations, :user_id, :integer
  end
end
