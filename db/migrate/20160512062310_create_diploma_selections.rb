class CreateDiplomaSelections < ActiveRecord::Migration
  def change
    create_table :diploma_selections do |t|
      t.string :name
      t.boolean :active
      t.text :description

      t.timestamps
    end
  end
end
