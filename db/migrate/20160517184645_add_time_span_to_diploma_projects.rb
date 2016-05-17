class AddTimeSpanToDiplomaProjects < ActiveRecord::Migration
  def change
    add_column :diploma_projects, :time_span, :string
  end
end
