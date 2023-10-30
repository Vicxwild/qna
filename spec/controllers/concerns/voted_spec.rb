require "rails_helper"

shared_examples_for "voted" do
  let!(:user) { create(:user) }
  let!(:another_user) { create(:user) }
  let!(:voteable) { create(described_class.to_s.sub!("Controller", "").underscore.singularize.to_sym) }

  describe "PATCH #like" do
    let!(:vote) { create(:vote, user: another_user, voteable: voteable, value: 1) }

    subject(:like) do
      patch :like, params: {
        id: voteable.id,
        format: :json
      }
    end

    context "Authenticated user" do
      before { login(user) }

      it "respond status OK" do
        like
        expect(response.status).to eq 200
      end

      it "count votes increment by 1" do
        expect { like }.to change { voteable.reload.votes_sum }.from(1).to(2)
      end
    end

    context "Unauthenticated user" do
      it "response status unauthorized" do
        like
        expect(response.status).to eq 401
      end
    end
  end

  describe "PATCH #dislike" do
    let!(:vote) { create(:vote, user: another_user, voteable: voteable, value: -1) }

    subject(:dislike) do
      patch :dislike, params: {
        id: voteable.id,
        format: :json
      }
    end

    context "Authenticated user" do
      before { login(user) }

      it "respond status OK" do
        dislike
        expect(response.status).to eq 200
      end

      it "count votes decrease by 1" do
        expect { dislike }.to change { voteable.reload.votes_sum }.from(-1).to(-2)
      end
    end

    context "Unauthenticated user" do
      it "response status unauthorized" do
        dislike
        expect(response.status).to eq 401
      end
    end
  end

  describe "PATCH #revote" do
    let!(:vote) { create(:vote, user: another_user, voteable: voteable, value: 1) }

    subject(:revote) do
      patch :revote, params: {
        id: voteable.id,
        format: :json
      }
    end

    context "Authenticated user" do
      before { login(another_user) }

      it "respond status OK" do
        revote
        expect(response.status).to eq 200
      end

      it "count votes decrease by 1" do
        expect { revote }.to change { voteable.reload.votes_sum }.from(1).to(0)
      end
    end

    context "Unauthenticated user" do
      it "response status unauthorized" do
        revote
        expect(response.status).to eq 401
      end
    end
  end
end
