require "rails_helper"

RSpec.describe QuestionsController, type: :controller do
  describe "GET #show" do
    let(:question) { create(:question) }

    before { get :show, params: {id: question} }

    it "assigns the requested question to @question" do
      expect(assigns(:question)).to eq question
    end

    it "renders show view" do
      expect(response).to render_template :show
    end
  end
end
