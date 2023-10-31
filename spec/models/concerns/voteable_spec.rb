require "rails_helper"

shared_examples_for "voteable" do
  it { should have_many(:votes).dependent(:destroy) }

  let!(:voteable) { create(described_class.to_s.underscore.to_sym) }

  describe "#votes_sum" do
    it "check for votes: 1, -1, 1" do
      create(:vote, voteable: voteable, value: 1)
      create(:vote, voteable: voteable, value: -1)
      create(:vote, voteable: voteable, value: 1)

      expect(voteable.votes_sum).to eq 1
    end

    it "check for votes: -1, -1, 1" do
      create(:vote, voteable: voteable, value: -1)
      create(:vote, voteable: voteable, value: -1)
      create(:vote, voteable: voteable, value: 1)

      expect(voteable.votes_sum).to eq(-1)
    end
  end

  describe "#voted?" do
    let(:user) { create(:user) }

    context "when user alredy voted" do
      it "returns true" do
        create(:vote, voteable: voteable, user: user)
        expect(voteable.voted?(user)).to be_truthy
      end
    end

    context "when user didn't vote" do
      it "returns fale" do
        expect(voteable.voted?(user)).to be_falsey
      end
    end
  end
end
