class AnswersController < ApplicationController
  helper_method :current_question

  def show
    @answer = find_answer
  end

  def new
    @answer = current_question.answers.new
  end

  def create
    @answer = current_question.answers.new(answer_params)

    if @answer.save
      redirect_to question_answer_path(@current_question, @answer)
    else
      render :new
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
