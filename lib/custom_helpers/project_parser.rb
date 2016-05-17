require 'csv'

module CustomHelpers::ProjectsParser

	def parse_file(file, import_object)
		line = 1
		output = { status: 'parsed_successfully', message: 'File was parsed', results: {} }

		CSV.foreach(file, headers: true, col_sep: ',') do |file_line|
			line += 1
			output[:results]["Line #{line}"] = parse_row(file_line)
		end
		output
	end

	def parse_row(line)
		project = DiplomaProject.where(name: line['title'])

		if project.any?
			'Existing Projects'
		else
			begin
				DiplomaProject.create(
					name: line['title'],
					max_students: line['number_of_students'],
					duration: line['duration']
					description: line['description']
					)
			rescue => e 
				e.to_s
			end
		end
	end
end

