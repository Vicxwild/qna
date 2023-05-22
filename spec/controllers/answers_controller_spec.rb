require "rails_helper"

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }

  describe "POST #create" do
    context "Authenticated user" do
      before { login(user) }

      context "with valid attributes" do
        it "saves a new answer in the database" do
          expect { post :create, params: {answer: attributes_for(:answer), question_id: question, author_id: user}, format: :js }.to change(question.answers, :count).by(1)
        end

        it "re-renders template create" do
          post :create, params: {answer: attributes_for(:answer), question_id: question, author_id: user}, format: :js
          expect(response).to render_template :create
        end
      end

      context "with invalid attributes" do
        it "does not save the answer" do
          expect { post :create, params: {answer: attributes_for(:answer, :invalid), question_id: question, author_id: user}, format: :js }.to_not change(Answer, :count)
        end

        it "re-renders create template" do
          post :create, params: {answer: attributes_for(:answer, :invalid), question_id: question, author_id: user}, format: :js
          expect(response).to render_template :create
        end
      end
    end

    describe "PATCH #update" do
      let!(:answer) { create(:answer, question: question, author: user) }

      context "Authenticated user" do
        before { login(user) }

        context "with valid attributes" do
          it "changes answer attributes" do
            patch :update, params: {id: answer, question_id: question, answer: {body: "new body"}}, format: :js
            answer.reload
            expect(answer.body).to eq "new body"
          end

          it "renders update view" do
            patch :update, params: {id: answer, question_id: question, answer: {body: "new body"}}, format: :js
            expect(response).to render_template :update
          end
        end

        context "with invalid attributes" do
          it "doesn't change answer attributes" do
            expect do
              patch :update, params: {id: answer, question_id: question, answer: attributes_for(:answer, :invalid)}, format: :js
            end.to_not change(answer, :body)
          end

          it "renders update view" do
            patch :update, params: {id: answer, question_id: question, answer: attributes_for(:answer, :invalid)}, format: :js
            expect(response).to render_template :update
          end
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
