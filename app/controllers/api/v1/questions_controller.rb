module Api
  module V1
    class QuestionsController < Api::V1::BaseController
      def index
        @questions = Question.all

        render json: @questions, each_serializer: QuestionSerializer
      end

      def show
        @question = find_question
        render json: @question, serializer: QuestionSerializer
      end

      def create
        authorize Question

        @question = Question.new(question_params.merge(author: current_user))

        if @question.save
          render json: @question, serializer: QuestionSerializer
        else
          render json: {errors: @question.errors.full_messages}, status: :unprocessable_entity
        end
      end

      def update
        @question = find_question

        authorize @question

        if @question.update(question_params)
          render json: @question, serializer: QuestionSerializer
        else
          render json: {errors: @question.errors.full_messages}, status: :unprocessable_entity
        end
      end

      def destroy
        @question = find_question

        authorize @question

        if @question.destroy
          head :no_content
        else
          render json: {errors: @question.errors.full_messages}, status: :unprocessable_entity
        end
      end

      private

      def find_question
        Question.find(params[:id])
      end

      def question_params
        params.require(:question).permit(:title, :body)
      end
    end
  end
end
