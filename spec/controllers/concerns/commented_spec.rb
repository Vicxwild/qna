require "rails_helper"

shared_examples_for "commented" do
  let!(:user) { create(:user) }
  let!(:commentable) { create(described_class.to_s.sub!("Controller", "").underscore.singularize.to_sym) }

  let!(:params) do
    if described_class.to_s == "AnswersController"
      {id: commentable.id, question_id: commentable.question.id, body: "Comment body", format: :json}
    else
      {id: commentable.id, body: "Comment body", format: :json}
    end
  end

  describe "PATCH #add_comment" do
    let!(:comment) { create(:comment, commentable: commentable) }

    subject(:add_comment) do
      patch :add_comment, params: params
    end

    context "Authenticated user" do
      before { login(user) }

      it "respond status OK" do
        add_comment
        expect(response.status).to eq 200
      end

      it "add comment to commentable" do
        add_comment

        last_comment = commentable.reload.comments.last

        expect(last_comment.body).to eq "Comment body"
      end

      it "increment comments count of commentable" do
        expect { add_comment }.to change { commentable.reload.comments.length }.by(1)
      end
    end

    context "Unauthenticated user" do
      it "response status unauthorized" do
        add_comment
        expect(response.status).to eq 401
      end
    end
  end
end
