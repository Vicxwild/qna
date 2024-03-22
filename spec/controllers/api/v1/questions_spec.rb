require "rails_helper"

describe "Questions API", type: :request do
  let(:headers) {
    {"CONTENT_TYPE" => "application/json",
     "ACCEPT" => "application/json"}
  }

  describe "GET /api/v1/questions" do
    let(:access_token) { create(:access_token).token }
    let(:api_path) { "/api/v1/questions" }
    let(:method) { :get }
    let!(:questions) { create_list(:question, 2) }
    let(:question) { questions.first }
    let!(:answers) { create_list(:answer, 3, question: question) }

    it_behaves_like "API Authorizable"

    context "authorized" do
      let(:question_response) { json_response_body["questions"].first }

      before { get api_path, params: {access_token: access_token}, headers: headers }

      it "returns list of questions" do
        expect(json_response_body["questions"].size).to eq 2
      end

      it "returns all public fields" do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it "contains user object" do
        expect(question_response["author"]["id"]).to eq question.author_id
      end
    end
  end

  describe "GET /api/v1/questions/:id" do
    let(:access_token) { create(:access_token).token }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:method) { :get }
    let!(:question) { create(:question, :with_files) }
    let!(:comments) { create_list(:comment, 2, commentable: question) }
    let!(:links) { create_list(:link, 2, linkable: question) }

    it_behaves_like "API Authorizable"

    context "authorized" do
      let(:question_response) { json_response_body["question"] }

      before { get api_path, params: {access_token: access_token}, headers: headers }

      it "returns all public fields" do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      describe "comments" do
        let(:comments_responce) { question_response["comments"] }
        let(:comment_responce) { question_response["comments"].first }

        it "contains list of comments" do
          expect(comments_responce.count).to eq 2
        end

        it "returns all fields" do
          %w[id body created_at updated_at].each do |attr|
            expect(comment_responce[attr]).to eq question.comments.first.send(attr).as_json
          end
        end

        it "returns author object" do
          expect(comment_responce["author"]["id"]).to eq question.comments.first.author_id
        end
      end

      describe "links" do
        let(:links_responce) { question_response["links_list"].first }

        it "contains list of links" do
          expect(links_responce.count).to eq 2
        end

        it "returns all fields" do
          %w[name url].each do |attr|
            expect(links_responce[attr]).to eq question.links.first.send(attr).as_json
          end
        end
      end

      describe "files" do
        let(:files_responce) { question_response["files_list"].first }

        it "contains list of links" do
          expect(files_responce.count).to eq 2
        end

        it "returns all fields" do
          %w[name url].each do |attr|
            expect(files_responce).to have_key(attr)
          end
        end
      end
    end
  end

  describe "POST /api/v1/questions" do
    let(:access_token) { create(:access_token).token }
    let(:api_path) { "/api/v1/questions" }
    let(:method) { :post }
    let(:question_params) { {title: "new title", body: "new body"} }
    let(:request_params) { question_params.merge({access_token: access_token}).to_json }

    it_behaves_like "API Authorizable", skip_authorized: true

    context "with right attrs" do
      let(:question_response) { json_response_body["question"] }

      before { post api_path, params: request_params, headers: headers }

      it "returns 200 status" do
        expect(response).to be_successful
      end

      it "returns public fields" do
        %w[id title body created_at].each do |attr|
          expect(question_response).to have_key(attr)
        end
      end

      it "returns entered attributes" do
        expect(question_response).to include(question_params.stringify_keys)
      end
    end

    context "with wrong attrs" do
      let(:request_params) { {title: nil}.merge({access_token: access_token}).to_json }

      before { post api_path, params: request_params, headers: headers }

      it "responce with unprocessable entity status" do
        expect(response.status).to eq 422
      end

      it "returns errors" do
        expect(json_response_body["errors"]).to eq ["Title can't be blank", "Body can't be blank"]
      end
    end
  end

  describe "PATCH /api/v1/questions/:id" do
    let(:access_token) { create(:access_token, resource_owner_id: user.id).token }
    let(:user) { create(:user) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:method) { :patch }
    let!(:question) { create(:question, author_id: user.id) }
    let(:question_params) { {title: "updated title", body: "updated body"} }
    let(:request_params) { question_params.merge({access_token: access_token}).to_json }

    it_behaves_like "API Authorizable", skip_authorized: true

    context "with right attrs" do
      let(:question_response) { json_response_body["question"] }

      before { patch api_path, params: request_params, headers: headers }

      it "returns 200 status" do
        expect(response).to be_successful
      end

      it "returns public fields" do
        %w[id title body created_at].each do |attr|
          expect(question_response).to have_key(attr)
        end
      end

      it "returns entered attributes" do
        expect(question_response).to include(question_params.stringify_keys)
      end
    end

    context "with wrong attrs" do
      let(:request_params) { {title: nil}.merge({access_token: access_token}).to_json }

      before { patch api_path, params: request_params, headers: headers }

      it "responce with unprocessable entity status" do
        expect(response.status).to eq 422
      end

      it "returns errors" do
        expect(json_response_body["errors"]).to eq ["Title can't be blank"]
      end
    end
  end
end
