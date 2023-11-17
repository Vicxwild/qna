require "rails_helper"

RSpec.describe FilePolicy, type: :policy do
  let(:user) { create :user }
  let(:admin) { create :user, admin: true }
  let(:file) { fixture_file_upload("#{Rails.root}/spec/rails_helper.rb", "text/plain") }
  let(:file_parent) { create(:question, author: user, files: [file]) }

  subject { described_class }

  permissions :destroy? do
    it "grants access if user is creator of file parent" do
      expect(subject).to permit(user, file_parent)
    end

    it "grants access if user is admin" do
      expect(subject).to permit(admin, file_parent)
    end

    it "denies access if user is not an author" do
      expect(subject).to_not permit(User.new, file_parent)
    end
  end
end
