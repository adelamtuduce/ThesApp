# == Schema Information
#
# Table name: diploma_selections
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  active      :boolean
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#

class DiplomaSelection < ActiveRecord::Base
end
