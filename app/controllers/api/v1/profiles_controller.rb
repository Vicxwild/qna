module Api
  module V1
    class ProfilesController < Api::V1::BaseController
      def others
        # binding.pry
        @users = User.where.not(id: current_resource_owner.id)
        render json: {users: @users}
      end

      def me
        #  current_user is unavailable - it's Devise method
        render json: current_resource_owner
      end
    end
  end
end
