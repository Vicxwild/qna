require "rails_helper"

describe "Answers API", type: :request do
  let(:access_token) { create(:access_token).token }
  let(:headers) {
    {"CONTENT_TYPE" => "application/json",
     "ACCEPT" => "application/json"}
  }

  describe "GET /api/v1/questions/:question_id/answers" do
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    let(:method) { :get }
    let!(:question) { create(:question) }
    let!(:answers) { create_list(:answer, 3, question: question) }
    let(:answer) { answers.first }

    it_behaves_like "API Authorizable"

    context "authorized" do
      let(:answer_response) { json_response_body["answers"].first }

      before { get api_path, params: {access_token: access_token}, headers: headers }

      it "returns list of answers" do
        expect(json_response_body["answers"].size).to eq 3
      end

      it "returns all public fields" do
        %w[id body created_at updated_at].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end

      it "contains user object" do
        expect(answer_response["author"]["id"]).to eq answer.author_id
      end
    end
  end

  describe "GET /api/v1/answers/:id" do
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    let(:method) { :get }
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, :with_files, question: question) }
    let!(:comments) { create_list(:comment, 2, commentable: answer) }
    let!(:links) { create_list(:link, 2, linkable: answer) }

    it_behaves_like "API Authorizable"

    context "authorized" do
      let(:answer_response) { json_response_body["answer"] }

      before { get api_path, params: {access_token: access_token}, headers: headers }

      it "returns all public fields" do
        %w[id body created_at updated_at].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end

      describe "comments" do
        let(:comments_responce) { answer_response["comments"] }
        let(:comment_responce) { answer_response["comments"].first }

        it "contains list of comments" do
          expect(comments_responce.count).to eq 2
        end

        it "returns all fields" do
          %w[id body created_at updated_at].each do |attr|
            expect(comment_responce[attr]).to eq answer.comments.first.send(attr).as_json
          end
        end

        it "returns author object" do
          expect(comment_responce["author"]["id"]).to eq answer.comments.first.author_id
        end
      end

      describe "links" do
        let(:links_responce) { answer_response["links_list"].first }

        it "contains list of links" do
          expect(links_responce.count).to eq 2
        end

        it "returns all fields" do
          %w[name url].each do |attr|
            expect(links_responce[attr]).to eq answer.links.first.send(attr).as_json
          end
        end
      end

      describe "files" do
        let(:files_responce) { answer_response["files_list"].first }

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
end
