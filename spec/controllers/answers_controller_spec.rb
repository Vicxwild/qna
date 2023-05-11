require "rails_helper"

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }

  describe "POST #create" do
    context "Authenticated user" do
      before { login(user) }

      context "with valid attributes" do
        it "saves a new answer in the database" do
          expect { post :create, params: {answer: attributes_for(:answer), question_id: question, author_id: user} }.to change(Answer, :count).by(1)
        end

        it "re-renders question show view" do
          post :create, params: {answer: attributes_for(:answer), question_id: question, author_id: user}
          expect(response).to redirect_to question_path(question)
        end
      end

      context "with invalid attributes" do
        it "does not save the answer" do
          expect { post :create, params: {answer: attributes_for(:answer, :invalid), question_id: question, author_id: user} }.to_not change(Answer, :count)
        end

        it "re-renders question show view" do
          post :create, params: {answer: attributes_for(:answer, :invalid), question_id: question, author_id: user}
          expect(response).to render_template "questions/show"
        end
      end
    end

    context "Unauthenticated user" do
      it "doesn't save a new answer in the database" do
        expect { post :create, params: {answer: attributes_for(:answer), question_id: question, author_id: user} }.to_not change(Answer, :count)
      end

      it "redirects to sign in page" do
        post :create, params: {answer: attributes_for(:answer), question_id: question, author_id: user}
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "DELETE #destroy" do
    context "Authenticated user" do
      before { login(user) }

      let!(:answer) { create(:answer, question: question, author: user) }

      it "deletes the answer" do
        expect { delete :destroy, params: {id: answer, question_id: question, author_id: user} }.to change(Answer, :count).by(-1)
      end

      it "re-renders question path" do
        delete :destroy, params: {id: answer, question_id: question, author_id: user}
        expect(response).to redirect_to question_path(question)
      end
    end

    context "Unauthenticated user" do
      let!(:answer) { create(:answer, question: question, author: user) }

      it "can't delete the question" do
        expect { delete :destroy, params: {id: answer, question_id: question, author_id: user} }.to_not change(Answer, :count)
      end

      it "redirects to sign in page" do
        delete :destroy, params: {id: answer, question_id: question, author_id: user}
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
