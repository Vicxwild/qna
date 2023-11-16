require "rails_helper"

RSpec.describe AnswerPolicy, type: :policy do
  let(:user) { create :user }
  let(:admin) { create :user, admin: true }

  subject { described_class }

  permissions :new?, :create? do
    it "grants access if user exists" do
      expect(subject).to permit(user, build(:answer))
    end
  end

  permissions :update?, :destroy? do
    it "grants access if user is author of answer" do
      expect(subject).to permit(user, build(:answer, author_id: user.id))
    end

    it "grants access if user is admin" do
      expect(subject).to permit(admin, build(:answer))
    end

    it "denies access if user is not an author" do
      expect(subject).to_not permit(user, build(:answer))
    end
  end

  permissions :best? do
    it "grants access if user is author of question" do
      question = create(:question, author_id: user.id)
      expect(subject).to permit(user, build(:answer, question_id: question.id))
    end

    it "grants access if user is admin" do
      expect(subject).to permit(admin, build(:answer))
    end

    it "denies access if user is not an author of question" do
      expect(subject).to_not permit(user, build(:answer))
    end
  end
end
