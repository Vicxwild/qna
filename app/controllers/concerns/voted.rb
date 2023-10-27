module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_voteable, only: %w[like dislike]
  end

  def like
    vote(1)
  end

  def dislike
    vote(-1)
  end

  private

  def vote(value)
    @vote = @voteable.votes.new(user: current_user, value: value)

    respond_to do |format|
      if @vote.save
        format.json { render json: {vote_sum: @voteable.votes_sum} }
      else
        render json: @vote.errors.messages, status: :unprocessable_entity
      end
    end
  end

  def model_klass
    controller_name.classify.constantize
  end

  def set_voteable
    @voteable = model_klass.find(params[:id])
    instance_variable_set("@#{controller_name.singularize}", @voteable)
  end
end
