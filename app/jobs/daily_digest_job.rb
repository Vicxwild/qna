class DailyDigestJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Questions::DailyDigestService.new.send_digest
  end
end
