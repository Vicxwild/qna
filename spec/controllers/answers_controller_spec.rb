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

      context "Unauthenticated user" do
        it "not changes answer attributes" do
          expect { patch :update, params: {id: answer, question_id: question, answer: {body: "new body"}} }.to_not change(answer, :body)
        end

        it "redirects to sign in page" do
          patch :update, params: {id: answer, question_id: question, answer: {body: "new body"}}
          expect(response).to redirect_to new_user_session_path
        end
      end
    end
  end

  describe "DELETE #destroy" do
    context "Authenticated user" do
      before { login(user) }

      context "user's answers" do
        let!(:answer) { create(:answer, question: question, author: user) }

        it "deletes the answer" do
          expect { delete :destroy, params: {id: answer, question_id: question, author_id: user}, format: :js }.to change(Answer, :count).by(-1)
        end

        it "render destroy" do
          delete :destroy, params: {id: answer, question_id: question, author_id: user}, format: :js
          expect(response).to render_template :destroy
        end
      end

      context "other user answers" do
        let!(:answer) { create(:answer, question: question, author: create(:user)) }

        it "can't delete the question" do
          expect { delete :destroy, params: {id: answer, question_id: question, author_id: user}, format: :js }.to_not change(Answer, :count)
        end
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

  describe "PATCH #best" do
    let!(:answer) { create(:answer, question: question, author: user) }

    context "Authenticated user" do
      context "user's question" do
        before { login(user) }

        it "can select the best answer" do
          patch :best, params: {id: answer, question_id: question}, format: :js
          answer.reload
          expect(answer.best).to eq true
        end

        it "renders best best template" do
          patch :best, params: {id: answer, question_id: question}, format: :js
          expect(response).to render_template :best
        end
      end

      context "other user's question" do
        before { login create(:user) }

        it "can select the best answer" do
          patch :best, params: {id: answer, question_id: question}, format: :js
          answer.reload
          expect(answer.best).to eq false
        end
      end

      context "can select the best answer if there is already the best answer" do
        let!(:answer_2) { create(:answer, question: question, author: user, best: true) }

        before { login(user) }

        it "can select the best answer one more time" do
          patch :best, params: {id: answer, question_id: question}, format: :js
          answer.reload
          expect(answer.best).to eq true
        end

        it "unmark previous best answer" do
          patch :best, params: {id: answer, question_id: question}, format: :js
          answer_2.reload
          expect(answer_2.best).to eq false
        end
      end
    end

    context "Unauthenticated user" do
      it "can't select the best answer" do
        patch :best, params: {id: answer, question_id: question}, format: :js
        answer.reload
        expect(answer.best).to eq false
      end
    end
  end

  it_behaves_like "voted"
end
