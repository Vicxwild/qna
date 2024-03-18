module Api
  module V1
    class BaseController < ApplicationController
      include ActiveStorage::SetCurrent

      protect_from_forgery with: :null_session # CSRF attacks protection

      before_action :doorkeeper_authorize!

      private

      def current_resource_owner
        return unless doorkeeper_token

        @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id)
      end

      private

      def pundit_user
        current_resource_owner
      end
    end
  end
end
