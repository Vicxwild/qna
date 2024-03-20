module Api
  module V1
    class AnswersController < Api::V1::BaseController
      def index
        @answers = Question.find(params[:question_id]).answers

        render json: @answers, each_serializer: AnswerSerializer
      end

      def show
        @answer = Answer.find(params[:id])

        render json: @answer, serializer: AnswerSerializer
      end
    end
  end
end
