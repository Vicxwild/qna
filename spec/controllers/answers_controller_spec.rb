require "rails_helper"

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }

  describe "GET #show" do
    let(:answer) { create(:answer, question: question) }

    before { get :show, params: {id: answer, question_id: question} }

    it "assigns the requested answer to @answer" do
      expect(assigns(:answer)).to eq answer
    end

    it "renders show view" do
      expect(response).to render_template :show
    end
  end

  describe "GET #new" do
    before { get :new, params: {question_id: question} }

    it "assigns a new Answer to @answer" do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it "renders new view" do
      expect(response).to render_template :new
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "saves a new answer in the database" do
        expect { post :create, params: {answer: attributes_for(:answer), question_id: question} }.to change(Answer, :count).by(1)
      end

      it "re-renders show view" do
        post :create, params: {answer: attributes_for(:answer), question_id: question}
        expect(response).to redirect_to question_answer_path(question, assigns(:answer))
      end
    end

    context "with invalid attributes" do
      it "does not save the answer" do
        expect { post :create, params: {answer: attributes_for(:answer, :invalid), question_id: question} }.to_not change(Answer, :count)
      end

      it "re-renders new view" do
        post :create, params: {answer: attributes_for(:answer, :invalid), question_id: question}
        expect(response).to render_template :new
      end
    end
  end
end
