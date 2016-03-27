class CreatePersonalInformations < ActiveRecord::Migration
  def change
    create_table :personal_informations do |t|
      t.string :first_name
      t.string :last_name
      t.string :code
      t.integer :age
      t.string :faculty
      t.integer :year

      t.timestamps
    end
  end
end
