require "rails_helper"

RSpec.describe OauthCallbacksController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe "GitHub" do
    let(:oauth_data) { {"provider" => "github", "uid" => 123} }

    it "finds user from oauth data" do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with("omniauth.auth").and_return(oauth_data)

      oauth_finder_instance = instance_double(Users::OauthFinder)

      expect(Users::OauthFinder).to receive(:new).with(oauth_data).and_return(oauth_finder_instance)
      expect(oauth_finder_instance).to receive(:call)
      get :github
    end

    context "user exists" do
      let!(:user) { create(:user) }

      before do
        allow_any_instance_of(Users::OauthFinder).to receive(:call).and_return(user)
        get :github
      end

      it "login user if it exists" do
        expect(subject.current_user).to eq user
      end

      it "redirect to root path" do
        expect(response).to redirect_to root_path
      end
    end

    context "user does't exist" do
      before do
        allow_any_instance_of(Users::OauthFinder).to receive(:call)
        get :github
      end

      it "redirects to root path" do
        expect(response).to redirect_to root_path
      end

      it "does not login user" do
        expect(subject.current_user).to_not be
      end
    end
  end
end
