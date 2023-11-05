class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: :show
  helper_method :current_question

  after_action :publish_answer, only: [:create]

  def create
    @answer = current_question.answers.create(answer_params.merge(author: current_user))
    @answer.save
  end

  def update
    @answer = find_answer
    @answer.update(answer_params) if @answer.author == current_user
  end

  def destroy
    @answer = find_answer
    @answer.destroy if @answer.author == current_user
  end

  def best
    @answer = find_answer
    @answer.set_the_best if current_question.author == current_user
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
    ActionCable.server.broadcast("answers_channel", {
      answer: {
        # данные ответа для передачи на клиент
      }
    })
  end
end
