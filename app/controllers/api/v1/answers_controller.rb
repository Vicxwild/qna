module Api
  module V1
    class AnswersController < Api::V1::BaseController
      def index
        @answers = find_question_answers

        render json: @answers, each_serializer: AnswerSerializer
      end

      def show
        @answer = Answer.find(params[:id])

        render json: @answer, serializer: AnswerSerializer
      end

      def create
        authorize Answer

        @answer = find_question_answers.new(answer_params.merge(author: current_resource_owner))

        if @answer.save
          render json: @answer, serializer: AnswerSerializer
        else
          render json: {errors: @answer.errors.full_messages}, status: :unprocessable_entity
        end
      end

      private

      def find_question_answers
        Question.find(params[:question_id]).answers
      end

      def answer_params
        params.require(:answer).permit(:body)
      end
    end
  end
end
