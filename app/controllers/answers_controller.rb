class AnswersController < ApplicationController
  helper_method :current_question

  def show
    @answer = find_answer
  end

  private

  def current_question
    @current_question ||= Question.find(params[:question_id])
  end

  def find_answer
    current_question.answers.find(params[:id])
  end
end
