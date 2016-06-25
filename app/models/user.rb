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
#  approved               :boolean          default(FALSE), not null
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable
  has_one :role

  has_one :personal_information, dependent: :destroy
  has_many :documents, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_one :student, dependent: :destroy
  has_one :teacher, dependent: :destroy

  
  scope :in_interval, -> (start_date, end_date) { where("date(users.created_at) >= date('#{start_date}') AND date(users.created_at) <= date('#{end_date}')") }

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

  def role
    Role.find(role_id)
  end

  def regular_user?
    %w(Student Profesor).include?(Role.find(role_id).name)
  end

  def admin_user?
    %w(admin).include?(Role.find(role_id).name)
  end

  def incomplete_information?
    return personal_information.student_incomplete? if student?
    return personal_information.teacher_incomplete? if teacher?
  end

  def self.users_report(temporary_local_file)
    CSV.open(
      temporary_local_file,
      'w',
      write_headers: true,
      headers: ['Name', 'Faculty', 'Email', 'Role']
    ) do |csv|
      if any?
        joins(:personal_information).all.each do |user|
          name = user.personal_information.name
          faculty = user.personal_information.faculty_name
          email = user.email
          role = user.role.name
          data_out = [ name, faculty, email, role]
          csv << data_out
        end
      else
        csv << ['There are no users yet.']
      end
    end
    temporary_local_file
  end

  def active_for_authentication? 
    super && approved? 
  end 

  def inactive_message 
    if !approved? 
      :not_approved 
    else 
      super # Use whatever other message 
    end 
  end
end
