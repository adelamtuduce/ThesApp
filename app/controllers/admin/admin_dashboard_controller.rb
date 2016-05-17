class Admin::AdminDashboardController < ApplicationController
	authorize_resource :class => false

	def settings
    @selection_modes = DiplomaSelection.all
  end

  def toggle_selection_mode
    selection = DiplomaSelection.find(params[:selection_id])
    selection.update_attributes(active: !selection.active)
    DiplomaSelection.where.not(id: selection.id).update_all(active: !selection.active)
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_url
  end


  def admin_chart_data
    start_valid = true
    end_valid   = true

    begin
      from = Date.parse(Date.strptime(params[:chart_from], '%m/%d/%Y').strftime('%Y-%m-%d')).beginning_of_day if params[:chart_from] && params[:chart_from].length == 10
    rescue ArgumentError
      start_valid = false
    end
    begin
      to = Date.parse(Date.strptime(params[:chart_to], '%m/%d/%Y').strftime('%Y-%m-%d')).beginning_of_day if params[:chart_to] && params[:chart_to].length == 10
    rescue ArgumentError
      end_valid = false
    end

    to   = Time.zone.now.to_date if to.nil? || !end_valid
    from = to - 6.days if from.nil? || !start_valid

    from = to if from > to
    result = []
    from.to_date.step(to.to_date) do |day|
      start = day.beginning_of_day.strftime("%Y-%m-%d %T")
      end_day = day.end_of_day.strftime("%Y-%m-%d %T")
      requests = EnrollRequest.in_interval(start, end_day)
      users = User.in_interval(start, end_day)
      students = Student.in_interval(start, end_day)
      teachers = Teacher.in_interval(start, end_day)
      documents = Document.in_interval(start, end_day)
      projects = DiplomaProject.in_interval(start, end_day).map(&:get_occupied).compact
      value = {
        x: day.to_date.strftime("%Y-%m-%d"),
        requests: requests.count,
        approved_requests: requests.where(accepted: true).count,
        declined_requests: requests.where(accepted: false).count,
        pending_requests: requests.where(accepted: nil).count,
        users: users.count,
        students: students.count,
        teachers: teachers.count,
        documents: documents.count,
        projects: projects.count

      }
      result << value
    end
    render json: { result: result }
  end

  def view_data
  end


	private
end