module Api
  module V1
    class QuestionsController < Api::V1::BaseController
      def index
        @questions = Question.all

        render json: @questions, each_serializer: QuestionSerializer
        # render json: @questions - searching QuestionSerializer automatically
        # render json: @questions.to_json(include: :answers) # to_json(include: :answers) adds associations to current object
      end

      def show
        @question = Question.find(params[:id])
        render json: @question, serializer: QuestionSerializer
      end
    end
  end
end
