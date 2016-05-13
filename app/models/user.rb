# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  role_id                :integer
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable
  has_one :role

  has_one :personal_information
  has_many :documents
  has_many :notifications
  has_one :student
  has_one :teacher

  def student?
  	Student.find_by(user_id: id)
  end

  def teacher?
  	Teacher.find_by(user_id: id)
  end

  def teacher
    Teacher.find_by(user_id: id)
  end

  def student
    Student.find_by(user_id: id)
  end

  def regular_user?
    puts Role.find(role_id).name
    %w(Student Profesor).include?(Role.find(role_id).name)
  end

  def incomplete_information?
    return personal_information.student_incomplete? if student?
    return personal_information.teacher_incomplete? if teacher?
  end
end
