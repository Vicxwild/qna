class AnswersController < ApplicationController
  before_action :authenticate_user!, except: :show
  helper_method :current_question

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

    if @answer.author == current_user
      @answer.destroy
      redirect_to question_path(current_question), notice: "Your answer successfully deleted."
    else
      redirect_to question_path(current_question), notice: "You can only delete your own answers."
    end
  end

  private

  def current_question
    @current_question ||= Question.find(params[:question_id])
  end

  def find_answer
    current_question.answers.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
