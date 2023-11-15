class ApplicationController < ActionController::Base
  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError do |exception|
    redirect_to root_path, alert: exception.message
  end
end
