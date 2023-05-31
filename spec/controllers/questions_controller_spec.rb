require "rails_helper"

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }

  describe "GET #index" do
    let(:questions) { create_list(:question, 3, author: user) }

    before { get :index }

    it "populates an array of all questions" do
      expect(assigns(:questions)).to match_array(questions)
    end

    it "renders index view" do
      expect(response).to render_template :index
    end
  end

  describe "GET #show" do
    before { get :show, params: {id: question} }

    it "assigns the requested question to @question" do
      expect(assigns(:question)).to eq question
    end

    it "renders show view" do
      expect(response).to render_template :show
    end

    it "assigns new answer for a question" do
      expect(assigns(:answer)).to be_a_new(Answer)
    end
  end

  describe "GET #new" do
    context "Authenticated user" do
      before { login(user) }

      before { get :new }

      it "assigns a new Question to @question" do
        expect(assigns(:question)).to be_a_new(Question)
      end

      it "renders new view" do
        expect(response).to render_template :new
      end
    end

    context "Unauthenticated user" do
      it "redirects to sign in page" do
        get :new
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "POST #create" do
    context "Authenticated user" do
      before { login(user) }

      context "with valid attributes" do
        it "saves a new question in the database" do
          expect { post :create, params: {question: attributes_for(:question), author: user} }.to change(Question, :count).by(1)
        end

        it "redirects to show view" do
          post :create, params: {question: attributes_for(:question), author: user}
          expect(response).to redirect_to assigns(:question)
        end
      end

      context "with invalid attributes" do
        it "does not save the question" do
          expect { post :create, params: {question: attributes_for(:question, :invalid), author_id: user} }.to_not change(Question, :count)
        end

        it "re-renders new view" do
          post :create, params: {question: attributes_for(:question, :invalid), author_id: user}
          expect(response).to render_template :new
        end
      end
    end

    context "Unauthenticated user" do
      it "doesn't save a new question in the database" do
        expect { post :create, params: {question: attributes_for(:question), author: user} }.to_not change(Question, :count)
      end

      it "redirects to sign in page" do
        post :create, params: {question: attributes_for(:question), author: user}
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "PATCH #update" do
    context "Authenticated user" do
      before { login(user) }

      context "with valid attributes" do
        it "assigns the requested to question to @question" do
          patch :update, params: {id: question, question: {title: "new title", body: "new body"}}, format: :js
          expect(assigns(:question)).to eq question
        end

        it "changes question attributes" do
          patch :update, params: {id: question, question: {title: "new title", body: "new body"}}, format: :js
          question.reload

          expect(question.title).to eq "new title"
          expect(question.body).to eq "new body"
        end

        it "renders update view" do
          patch :update, params: {id: question, question: {body: "new body"}}, format: :js
          expect(response).to render_template :update
        end
      end

      context "with invalid attributes" do
        it "doesn't change question attributes" do
          expect { patch :update, params: {id: question, question: attributes_for(:question, :invalid)}, format: :js }.to_not change(question, :body)
        end

        it "renders update view" do
          patch :update, params: {id: question, question: attributes_for(:question, :invalid)}, format: :js
          expect(response).to render_template :update
        end
      end
    end

    context "Unauthenticated user" do
      it "not changes question attributes" do
        expect { patch :update, params: {id: question, question: {title: "new title", body: "new body"}} }.to_not change(question, :body)
      end

      it "redirects to sign in page" do
        patch :update, params: {id: question, question: {title: "new title", body: "new body"}}
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "DELETE #destroy" do
    context "Authenticated user" do
      before { login(user) }

      let!(:question) { create(:question, author: user) }

      it "deletes the question" do
        expect { delete :destroy, params: {id: question} }.to change(Question, :count).by(-1)
      end

      it "redirects to root path" do
        delete :destroy, params: {id: question}
        expect(response).to redirect_to root_path
      end
    end

    context "Unauthenticated user" do
      let!(:question) { create(:question, author: user) }

      it "can't delete the question" do
        expect { delete :destroy, params: {id: question} }.to_not change(Question, :count)
      end

      it "redirects to sign in page" do
        delete :destroy, params: {id: question}
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
