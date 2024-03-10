module Api
  module V1
    class ProfilesController < Api::V1::BaseController
      def others
        @users = User.where.not(id: current_resource_owner.id)
        render json: @users, each_serializer: UserSerializer
      end

      def me
        #  current_user is unavailable - it's Devise method
        render json: current_resource_owner, serializer: UserSerializer
      end
    end
  end
end
