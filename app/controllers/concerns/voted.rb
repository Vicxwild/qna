module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_voteable, only: %w[like dislike]
  end

  def like
    vote_action(1)
  end

  def dislike
    vote_action(-1)
  end

  private

  def set_voteable
    @voteable = model_klass.find(params[:id])
    instance_variable_set("@#{controller_name.singularize}", @voteable)
  end

  def model_klass
    controller_name.classify.constantize
  end

  def vote_action(value)
    @voteable.votes.new(user_id: current_user.id, value: value)

    redirect_to @voteable, notice: "Your vote is taken into account." if @voteable.save
  end
end
