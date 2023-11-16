module Commented
  extend ActiveSupport::Concern

  included do
    before_action :set_commentable, only: %w[add_comment publish_comment]
    after_action :publish_comment, only: %w[add_comment]
  end

  def add_comment
    authorize @commentable, :add_comment?, policy_class: CommentPolicy
    @comment = @commentable.comments.new(comment_params.merge(author: current_user))
    @comment.save
    render json: {body: @comment.body, author_email: @comment.author.email}, status: :ok
  end

  private

  def comment_params
    params.permit(:body)
  end

  def model_klass
    controller_name.classify.constantize
  end

  def set_commentable
    @commentable = model_klass.find(params[:id])
    instance_variable_set("@#{controller_name.singularize}", @commentable)
  end

  def publish_comment
    return if @comment.errors.any?
    ActionCable.server.broadcast("comments_channel", broadcast_comment_attributes)
  end

  def broadcast_comment_attributes
    {
      body: @comment.body,
      author_email: @comment.author.email,
      commentable_type: @comment.commentable_type,
      commentable_id: @comment.commentable_id,
      sid: session.id.public_id
    }
  end
end
