class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter do
    resource = controller_name.singularize.to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end

  # before_action :check_current_user
  # include SessionsHelper
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  def new_session_path(scope)
    new_user_session_path
  end

  def check_current_user
    begin
      @user = User.find(params[:id])
    rescue => e
      redirect_to(root_url) 
    end
  end

  private

  def controller_namespace
    ap params[:controller]
    controller_name_segments = params[:controller].split('/')
    controller_name_segments.pop
    controller_namespace = controller_name_segments.join('/').camelize
  end

  def current_ability
    ap controller_namespace
    @current_ability ||= Ability.new(current_user, controller_namespace)
  end
end
