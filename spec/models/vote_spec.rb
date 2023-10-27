require "rails_helper"

RSpec.describe Vote, type: :model do
  it { should belong_to :voteable }
  it { should belong_to :user }

  it { should validate_presence_of :voteable }
  it { should validate_presence_of :user }

  let(:user) { create(:user) }
  let(:another_user) { create(:user) }

  let(:question) { create(:question, author: user) }

  describe "author_cant_vote validation" do
    it "prevents author from voting" do
      vote = build(:vote, voteable: question, user: user)

      expect(vote).not_to be_valid
      expect(vote.errors[:vote]).to include("Author can't vote")
    end
  end

  describe "user_cant_vote_twice validation" do
    it "prevents author from voting" do
      create(:vote, voteable: question, user: another_user)
      vote_2 = build(:vote, voteable: question, user: another_user)

      expect(vote_2).not_to be_valid
      expect(vote_2.errors[:vote]).to include("User can't vote twice")
    end
  end
end
