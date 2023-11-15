require "rails_helper"

RSpec.describe QuestionPolicy, type: :policy do
  let(:user) { create :user }
  let(:admin) { create :user, admin: true }

  subject { described_class }

  permissions :index?, :show? do
    it "grants access to all kind of users" do
      expect(subject).to permit(nil, create(:question))
    end
  end

  permissions :new?, :create? do
    it "grants access if user exists" do
      expect(subject).to permit(user, create(:question))
    end
  end

  permissions :update?, :destroy? do
    it "grants access if user is author of question or admin" do
      expect(subject).to permit(user, create(:question, author_id: user.id))
    end

    it "grants access if user is admin" do
      expect(subject).to permit(admin, create(:question))
    end

    it "denies access if user is not an author" do
      expect(subject).to_not permit(User.new, create(:question))
    end
  end
end
