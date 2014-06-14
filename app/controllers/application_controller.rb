class ApplicationController < ActionController::Base
  check_authorization unless: :devise_controller?
  skip_authorization_check only: [:index]
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery #with: :exception

  #before_filter :configure_permitted_parameters, if: :devise_controller?

  def index
  end

  rescue_from CanCan::AccessDenied do |ex|
    respond_to do |format|
      format.html { redirect_to root_url, alert: ex.message }
      format.json { render json: { errors: ex.message}, status: 401}
    end
  end

  protected

  def ensure_session_auth(sess)
    authenticate_or_request_with_http_token do |token, options|
      sess.key.key == token
    end
  end
end
