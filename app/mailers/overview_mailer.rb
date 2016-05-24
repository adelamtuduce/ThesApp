class OverviewMailer < ActionMailer::Base
  default from: "thesapp@cs.upt.ro"

  def send_report(report, email)
    @report = report
    return if @report.csv.nil?
    temporary_local_file = Rails.root.join("tmp/report-#{report.id}.csv")
    @report.csv.copy_to_local_file(:original, temporary_local_file) unless @report.csv.nil?

    name              = @report.title + '.csv'
    attachments[name] = File.read(temporary_local_file)

    mail to: email, subject: @report.title.humanize
  end
end