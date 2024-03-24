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

        return render_answer if @answer.save

        render_errors
      end

      def update
        @answer = Answer.find(params[:id])

        authorize @answer

        return render_answer if @answer.update(answer_params)

        render_errors
      end

      private

      def find_question_answers
        Question.find(params[:question_id]).answers
      end

      def answer_params
        params.require(:answer).permit(:body)
      end

      def render_answer
        render json: @answer, serializer: AnswerSerializer
      end

      def render_errors
        render json: {errors: @answer.errors.full_messages}, status: :unprocessable_entity
      end
    end
  end
end
