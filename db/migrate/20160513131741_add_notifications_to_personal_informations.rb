class AddNotificationsToPersonalInformations < ActiveRecord::Migration
  def change
    add_column :personal_informations, :notifications, :boolean, default: true
    add_column :personal_informations, :emails, :boolean, default: true
  end
end
