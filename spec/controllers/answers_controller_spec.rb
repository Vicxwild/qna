require "rails_helper"

RSpec.describe AnswersController, type: :controller do
  describe "GET #show" do
    let(:question) { create(:question) }
    let(:answer) { create(:answer, question: question) }

    before { get :show, params: {id: answer, question_id: question} }

    it "assigns the requested answer to @answer" do
      expect(assigns(:answer)).to eq answer
    end

    it "renders show view" do
      expect(response).to render_template :show
    end
  end
end
