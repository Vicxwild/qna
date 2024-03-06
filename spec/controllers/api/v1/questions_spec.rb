require "rails_helper"

describe "Questions API", type: :request do
  let(:headers) {
    {"CONTENT_TYPE" => "application/json",
     "ACCEPT" => "application/json"}
  }

  describe "GET /api/v1/questions" do
    context "unauthorized" do
      it "returns 401 status if there is no access_token" do
        get "/api/v1/questions", headers: headers
        expect(response.status).to eq 401
      end

      it "returns 401 status if access_token is invalid" do
        get "/api/v1/questions", params: {access_token: "123"}, headers: headers
        expect(response.status).to eq 401
      end
    end

    context "authorized" do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_response) { json_response_body["questions"].first }
      let!(:answers) { create_list(:answer, 3, question: question) }

      before { get "/api/v1/questions", params: {access_token: access_token.token}, headers: headers }

      it "returns 200 status" do
        expect(response).to be_successful
      end

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

      it "contains short title" do
        expect(question_response["short_title"]).to eq question.title.truncate(7)
      end

      context "answers" do
        let(:answer) { answers.first }
        let(:answer_response) { question_response["answers"] }

        it "returns list of answers" do
          expect(answer_response.size).to eq 3
        end

        it "returns all public fields" do
          %w[id body author_id created_at updated_at].each do |attr|
            expect(answer_response.first[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end
end
