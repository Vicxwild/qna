class QuestionsController < ApplicationController
  include Voted
  include Commented

  before_action :authenticate_user!, except: [:index, :show]

  after_action :publish_question, only: [:create]

  def index
    @questions = Question.all
    authorize @questions
  end

  def show
    @question = find_question
    authorize @question
    @answers = @question.answers.sort_by_best
    @answer = Answer.new
    @answer.links.new

    gon.push({
      question_id: @question.id,
      sid: session&.id&.public_id
    })
  end

  def new
    @question = Question.new
    authorize @question
    @question.links.build
    @reward = Reward.new(question: @question)
  end

  def create
    @question = Question.new(question_params)
    authorize @question
    @question.author = current_user

    if @question.save
      redirect_to @question, notice: "Your question successfully created."
    else
      render :new
    end
  end

  def update
    @question = find_question
    authorize @question
    @question.update(question_params)
  end

  def destroy
    @question = find_question
    authorize @question
    @question.destroy
    redirect_to root_path, notice: "Your question successfully deleted."
  end

  private

  def find_question
    Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [],
      links_attributes: [:id, :name, :url, :_destroy],
      reward_attributes: [:title, :image])
  end

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast("questions_channel", {
      question: {
        title: @question.title,
        url: url_for(@question)
      }
    })
  end
end
