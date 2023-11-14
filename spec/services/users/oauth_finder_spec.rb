require "rails_helper"

RSpec.describe Users::OauthFinder, type: :service do
  let!(:user) { create(:user) }
  let(:auth) { OmniAuth::AuthHash.new(provider: "github", uid: "123456") }
  subject { Users::OauthFinder.new(auth) }

  context "user alreadey has authorization" do
    it "returns the user" do
      user.authorizations.create(provider: "github", uid: "123456")
      expect(subject.call).to eq user
    end
  end

  context "user hasn't authorization" do
    let(:auth) { OmniAuth::AuthHash.new(provider: "github", uid: "123456", info: {email: user.email}) }

    context "user already exists" do
      it "does't create new user" do
        expect { subject.call }.to_not change(User, :count)
      end

      it "creates authorization" do
        expect { subject.call }.to change(user.authorizations, :count).by(1)
      end
    end

    context "user does't exist" do
      let(:auth) { OmniAuth::AuthHash.new(provider: "github", uid: "123456", info: {email: "new@user.com"}) }

      it "creates new user" do
        expect { subject.call }.to change(User, :count)
      end

      it "returns new user" do
        expect(subject.call).to be_a(User)
      end

      it "creates authorization" do
        user = subject.call
        expect(user.authorizations).to_not be_empty
      end

      it "fills user email" do
        user = subject.call
        expect(user.email).to eq auth.info[:email]
      end

      it "creates authorization with provider and uid" do
        authorization = subject.call.authorizations.first

        expect(authorization.provider).to eq auth.provider
        expect(authorization.uid).to eq auth.uid
      end
    end
  end
end
