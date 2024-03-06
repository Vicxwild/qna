module Api
  module V1
    class QuestionsController < Api::V1::BaseController
      def index
        @questions = Question.all
        render json: @questions # searching QuestionSerializer automatically
        # render json: @questions.to_json(include: :answers) # to_json(include: :answers) adds associations to current object
      end
    end
  end
end
