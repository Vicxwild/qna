class ApplicationController < ActionController::Base
  include Pundit::Authorization

  # rescue_from Pundit::NotAuthorizedError do |exception|
  #   redirect_to root_path, alert: exception.message
  # end

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized(exception)
    respond_to do |format|
      format.html do
        flash[:alert] = exception.message
        redirect_to root_path
      end
      format.json { render json: {error: "You don't have enough authority"}, status: :forbidden }
      format.js { render json: {error: "You don't have enough authority"}, status: :forbidden }
    end
  end
end
