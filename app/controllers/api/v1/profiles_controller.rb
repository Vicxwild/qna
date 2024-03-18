module Api
  module V1
    class ProfilesController < Api::V1::BaseController
      def others
        authorize User, policy_class: ProfilePolicy

        @users = User.where.not(id: current_resource_owner.id)
        render json: @users, each_serializer: UserSerializer
      end

      def me
        authorize User, policy_class: ProfilePolicy

        #  current_user is unavailable - it's Devise method
        render json: current_resource_owner, serializer: UserSerializer
      end
    end
  end
end
