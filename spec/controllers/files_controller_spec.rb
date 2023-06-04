require "rails_helper"

RSpec.describe FilesController, type: :controller do
  let(:user) { create(:user) }
  let(:file) { fixture_file_upload("#{Rails.root}/spec/rails_helper.rb", "text/plain") }
  let!(:question) { create(:question, author: user, files: [file]) }

  describe "DELETE #destroy" do
    context "Authenticated user" do
      before { login(user) }

      context "user is author of the question" do
        it "can remove attchment" do
          expect { delete :destroy, params: {id: question.files.first}, format: :js }.to change(question.files, :count).by(-1)
        end

        it "renders destroy view" do
          delete :destroy, params: {id: question.files.first}, format: :js
          expect(response).to render_template :destroy
        end
      end

      context "user isn't author of the question" do
        let!(:another_question) { create(:question, author: create(:user), files: [file]) }

        it "can't remove attchment" do
          expect { delete :destroy, params: {id: another_question.files.first}, format: :js }.to_not change(question.files, :count)
        end
      end
    end

    context "Unauthenticated user" do
      it "can't remove attchment" do
        expect { delete :destroy, params: {id: question.files.first}, format: :js }.to_not change(question.files, :count)
      end

      it "redirects to sign in page" do
        delete :destroy, params: {id: question.files.first}, format: :js
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
