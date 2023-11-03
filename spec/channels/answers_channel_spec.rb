require "rails_helper"

RSpec.describe AnswersChannel, type: :channel do
  it "successfully subscribes" do
    subscribe
    expect(subscription).to be_confirmed
    expect(subscription.streams).to eq ["answers_channel"]
  end
end
