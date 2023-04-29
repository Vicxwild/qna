class QuestionsController < ApplicationController
  def show
    @question = Question.find(params[:id])
  end

  def new
    @question = Question.new
  end
end
