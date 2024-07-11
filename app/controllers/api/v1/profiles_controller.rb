module Api
  module V1
    class ProfilesController < Api::V1::BaseController
      def others
        authorize User, policy_class: ProfilePolicy

        @users = User.where.not(id: current_user.id)
        render json: @users, each_serializer: UserSerializer
      end

      def me
        authorize User, policy_class: ProfilePolicy

        render json: current_user, serializer: UserSerializer
      end
    end
  end
end
