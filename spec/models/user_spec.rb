require "rails_helper"

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:rewards).dependent(:destroy) }
  it { should have_many(:votes) }
  it { should have_many(:authorizations).dependent(:destroy) }

  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:other_question) { create(:question, author: other_user) }

  describe "#author_of?" do
    context "when user is the author" do
      it "returns true" do
        expect(user.author_of?(question)).to be_truthy
      end
    end

    context "when user is not the author" do
      it "returns false" do
        expect(user.author_of?(other_question)).to be_falsey
      end
    end
  end
end
