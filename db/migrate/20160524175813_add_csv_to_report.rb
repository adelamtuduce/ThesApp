class AddCsvToReport < ActiveRecord::Migration
   def up
    add_attachment :reports, :csv
  end

  def down
    remove_attachment :reports, :csv
  end
end
