require "rails_helper"

RSpec.describe DailyDigestJob, type: :job do
  let(:service) { double("Questions::DailyDigestService") }

  before do
    allow(Questions::DailyDigestService).to receive(:new).and_return(service)
  end

  it "calls Questions::DailyDigestService#send_digest" do
    expect(service).to receive(:send_digest)
    DailyDigestJob.perform_now
  end
end
