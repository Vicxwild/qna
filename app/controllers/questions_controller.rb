class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @questions = Question.all
  end

  def show
    @question = Question.find(params[:id])
    @answer = @question.answers.new
    @answers = @question.answers
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)
    @question.author = current_user

    if @question.save
      redirect_to @question, notice: "Your question successfully created."
    else
      render :new
    end
  end

  def destroy
    @question = Question.find(params[:id])

    if @question.author == current_user
      @question.destroy
      redirect_to root_path, notice: "Your question successfully deleted."
    else
      redirect_to @question, notice: "You can only delete your own question."
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
