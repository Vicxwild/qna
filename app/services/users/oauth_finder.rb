module Users
  class OauthFinder
    attr_reader :auth

    def initialize(auth)
      @auth = auth
    end

    def call
    end
  end
end
