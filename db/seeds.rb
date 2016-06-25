# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# create admin for application
Conversation.destroy_all
DiplomaProject.destroy_all
DiplomaSelection.destroy_all
Document.destroy_all
EnrollRequest.destroy_all
Event.destroy_all
Faculty.destroy_all
Message.destroy_all
Notification.destroy_all
PersonalInformation.destroy_all
Report.destroy_all
Role.destroy_all
Section.destroy_all
Student.destroy_all
StudentEvent.destroy_all
Teacher.destroy_all
User.destroy_all
Conversation.reset_pk_sequence
DiplomaProject.reset_pk_sequence
DiplomaSelection.reset_pk_sequence
Document.reset_pk_sequence
EnrollRequest.reset_pk_sequence
Event.reset_pk_sequence
Faculty.reset_pk_sequence
Message.reset_pk_sequence
Notification.reset_pk_sequence
PersonalInformation.reset_pk_sequence
Report.reset_pk_sequence
Role.reset_pk_sequence
Section.reset_pk_sequence
Student.reset_pk_sequence
StudentEvent.reset_pk_sequence
Teacher.reset_pk_sequence
User.reset_pk_sequence
role = Role.new(name: 'admin')
role.save
User.create(email: 'admin@example.com', approved: true, password: 'Admin@pass', password_confirmation: 'Admin@pass', role_id: role.id)
Faculty.create_faculties
Role.create_roles
Section.create_sections
Report.create_reports
DiplomaSelection.create(name: 'unique', active: false, description: 'Allow students to choose only one diploma project at a time.')
DiplomaSelection.create(name: 'multiple', active: true, description: 'Allow students to choose multiple diploma projects at a time.')

