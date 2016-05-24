# == Schema Information
#
# Table name: documents
#
#  id                 :integer          not null, primary key
#  user_id            :integer
#  created_at         :datetime
#  updated_at         :datetime
#  file_file_name     :string(255)
#  file_content_type  :string(255)
#  file_file_size     :integer
#  file_updated_at    :datetime
#  download_url       :string(255)
#  enroll_request_id  :integer
#  diploma_project_id :integer
#

class DocumentsController < ApplicationController
	before_filter :authenticate_user!
  load_and_authorize_resource
	skip_before_filter :verify_authenticity_token
  before_action :set_document, only: [:destroy]
	
  def new
		@document = Document.new
	end

	def create
    if params[:document]['file'].original_filename.match(/\.(pdf|doc|txt|odt)$/i).nil?
      return redirect_to :back, alert: 'File format not supported. Please select a valid type file: word/pdf/text.'
    end
    if Document.find_by(file_file_name: params[:document]['file'].original_filename)
      return redirect_to :back, alert: "You already have a document uploaded with the name: #{params[:document]['file'].original_filename}"
    end
    if params[:document]['file'].size == 0
      return redirect_to :back, alert: 'File is empty. Please upload a valid file.'
    end
    @document = Document.new(document_params)
    @document.user_id = current_user.id
    @document.save
    if params['document']['diploma_project_id']
      @document.diploma_project_id =  params['document']['diploma_project_id']
    end


    if params['document']['request_id']
      @document.enroll_request_id =  params['document']['request_id']
    end
  	@document.download_url = @document.file.url
  	@document.save

    redirect_to :back
	end

  def destroy
    @document.file.destroy
    @document.destroy
  end

	private

  def set_document
    @document = Document.find(params['id'])
  end

  def document_params
    params.require(:document).permit(
      :file,
      :user_id,
      :enroll_request_id,
      :diploma_project_id)
  end
end
