module Commented
  extend ActiveSupport::Concern

  included do
    before_action :set_commentable, only: :add_comment
  end

  def add_comment
    @comment = @commentable.comments.new(comment_params.merge(author: current_user))

    if @comment.save
      render json: {body: @comment.body, author_email: @comment.author.email}, status: :ok
    else
      render json: @comment.errors.messages, status: :unprocessable_entity
    end
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
end
