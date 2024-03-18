require "rails_helper"

describe "Profiles API", type: :request do
  let(:headers) {
    {"CONTENT_TYPE" => "application/json",
     "ACCEPT" => "application/json"}
  }

  describe "GET /api/v1/profiles" do
    let(:access_token) { create(:access_token, resource_owner_id: user.id).token }
    let(:method) { :get }

    context "/others" do
      let(:user) { create(:user, admin: true) }
      let(:api_path) { "/api/v1/profiles/others" }

      it_behaves_like "API Authorizable"

      context "authorized" do
        let!(:users) { create_list(:user, 2) }
        let(:user_item) { users.first }
        let(:response_item) { json_response_body["users"].first }

        before { get api_path, params: {access_token: access_token}, headers: headers }

        it_behaves_like "fields returnable"

        it "have no current user" do
          json_response_body["users"].each do |user_response|
            expect(user_response["id"]).not_to eq user.id
          end
        end
      end

      context "user is not an admin" do
        let(:user) { create(:user) }

        before { get api_path, params: {access_token: access_token}, headers: headers }

        it "returns a 403 Forbidden status" do
          expect(response.status).to eq(403)
          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    context "/me" do
      let(:user) { create(:user) }
      let(:api_path) { "/api/v1/profiles/me" }

      it_behaves_like "API Authorizable"

      context "authorized" do
        let(:user_item) { user }
        let(:response_item) { json_response_body["user"] }

        before { get api_path, params: {access_token: access_token}, headers: headers }

        it_behaves_like "fields returnable"
      end
    end
  end
end
