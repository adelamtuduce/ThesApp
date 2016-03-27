class ChangeFacultyName < ActiveRecord::Migration
  def self.up
    change_column :personal_informations, :faculty, :integer
  end
 
  def self.down
    change_column :personal_informations, :faculty, :string
  end
end
