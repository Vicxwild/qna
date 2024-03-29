class AnswersController < ApplicationController
  include Voted
  include Commented

  before_action :authenticate_user!, except: :show
  helper_method :current_question

  after_action :publish_answer, only: [:create]

  def create
    @answer = current_question.answers.create(answer_params.merge(author: current_user))
    authorize @answer
    @answer.save
  end

  def update
    @answer = find_answer
    authorize @answer
    @answer.update(answer_params)
  end

  def destroy
    @answer = find_answer
    authorize @answer
    @answer.destroy
  end

  def best
    @answer = find_answer
    authorize @answer
    @answer.set_the_best
  end

  private

  def current_question
    @current_question ||= Question.with_attached_files.find(params[:question_id])
  end

  def find_answer
    current_question.answers.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [],
      links_attributes: [:id, :name, :url, :_destroy])
  end

  def publish_answer # метод отвечает за передачу данных в канал answers_channel
    return if @answer.errors.any?
    ActionCable.server.broadcast("answers_channel_#{current_question.id}", broadcast_attributes)
  end

  def broadcast_attributes
    votes = {
      sum: @answer.votes_sum,
      like_url: helpers.custom_polymorphic_vote_path(@answer, action: :like),
      dislike_url: helpers.custom_polymorphic_vote_path(@answer, action: :dislike)
    }

    files = @answer.files.map { |file| {filename: file.filename.to_s, url: url_for(file)} }
    links = @answer.links.map { |link| {name: link.name, url: link.url} }

    {
      answer: @answer.attributes.merge(votes: votes, files: files, links: links),
      sid: session.id.public_id
    }
  end
end
