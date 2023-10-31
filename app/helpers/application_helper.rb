module ApplicationHelper
  def custom_polymorphic_vote_path(voteable, action)
    if voteable.is_a?(Answer)
      send("#{action[:action]}_question_answer_path".to_sym, voteable.question, voteable)
    elsif voteable.is_a?(Question)
      send("#{action[:action]}_question_path".to_sym, voteable)
    end
  end
end
