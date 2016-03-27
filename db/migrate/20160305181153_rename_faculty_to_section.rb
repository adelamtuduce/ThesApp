class RenameFacultyToSection < ActiveRecord::Migration
  def change
  	rename_column :personal_informations, :faculty, :section_id
  end
end
