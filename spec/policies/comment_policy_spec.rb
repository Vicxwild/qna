require "rails_helper"

RSpec.describe CommentPolicy, type: :policy do
  subject { described_class }

  permissions :add_comment? do
    it "grants access if user exists" do
      expect(subject).to permit(User.new, build(:question))
    end

    it "denies access if user does't exists" do
      expect(subject).to_not permit(nil, build(:question))
    end
  end
end
