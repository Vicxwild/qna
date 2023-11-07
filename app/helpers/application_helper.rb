module ApplicationHelper
  def custom_polymorphic_vote_path(voteable, action)
    if voteable.is_a?(Answer)
      send("#{action[:action]}_question_answer_path".to_sym, voteable.question, voteable)
    elsif voteable.is_a?(Question)
      send("#{action[:action]}_question_path".to_sym, voteable)
    end
  end

  def custom_polymorphic_comment_path(commentable)
    if commentable.is_a?(Answer)
      send(:add_comment_question_answer_path, commentable.question, commentable)
    elsif commentable.is_a?(Question)
      send(:add_comment_question_path, commentable)
    end
  end
end
