class AddAvatarToPersonalInformations < ActiveRecord::Migration
  def up
    add_attachment :personal_informations, :avatar
  end

  def down
    remove_attachment :personal_informations, :avatar
  end
end