module Api
  module V1
    class BaseController < ApplicationController
      include ActiveStorage::SetCurrent

      protect_from_forgery with: :null_session # CSRF attacks protection

      before_action :doorkeeper_authorize!

      private

      def current_user
        return unless doorkeeper_token

        @current_user ||= User.find(doorkeeper_token.resource_owner_id)
      end

      private

      def pundit_user
        current_user
      end
    end
  end
end
