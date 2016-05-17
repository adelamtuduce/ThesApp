class ImportPatientsWorker
	extend CustomHelpers::ProjectsParser

	def self.perform(import_id)
		import_file = ImportProject.find(import_id)
		import_file.update_attributes(status: 'proceed_to_parsing')
		temporary_file = Rails.root.join("tmp/import_project_#{import_file.id}.csv")
    import_file.import.copy_to_local_file(:original, temporary_file) unless import_file.import.nil?
    parse_results = parse_file(temporary_file, import_file)
    import_job.update_columns(status: parse_results[:status])
	end
end