class DailyDigestJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Questions::DailyDigestService.call
  end
end
