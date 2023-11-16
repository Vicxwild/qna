module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_voteable, only: %w[like dislike revote]
  end

  def like
    authorize @voteable, :like?, policy_class: VotePolicy
    vote(1)
  end

  def dislike
    authorize @voteable, :dislike?, policy_class: VotePolicy
    vote(-1)
  end

  def revote
    authorize @voteable, :revote?, policy_class: VotePolicy
    destroy_vote
  end

  private

  def vote(value)
    @vote = @voteable.votes.new(user: current_user, value: value)

    respond_to do |format|
      if @vote.save
        format.json { render json: {vote_sum: @voteable.votes_sum} }
      else
        format.json { render json: @vote.errors.messages, status: :unprocessable_entity }
      end
    end
  end

  def model_klass
    controller_name.classify.constantize
  end

  def set_voteable
    @voteable = model_klass.find(params[:id])
    instance_variable_set("@#{kontroller_name}", @voteable)
  end

  def kontroller_name
    controller_name.singularize
  end

  def destroy_vote
    @vote = @voteable.votes.find_by(user_id: current_user)

    if @vote&.destroy
      render json: {vote_sum: @voteable.votes_sum}
    else
      render json: {error: "You can't revote for #{kontroller_name}"}, status: :unprocessable_entity
    end
  end
end
