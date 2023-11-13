module Users
  class OauthFinder
    attr_reader :auth

    def initialize(auth)
      @auth = auth
    end

    def call
      authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
      return authorization.user if authorization

      email = auth.info[:email]
      user = User.where(email: email).first

      if user
      else
        password = Devise.friendly_token[0, 20]
        user = User.create!(email: email, password: password, password_confirmation: password)
      end
      create_authorization(auth, user)

      user
    end

    private

    def create_authorization(auth, user)
      user.authorizations.create(provider: auth.provider, uid: auth.uid)
    end
  end
end
