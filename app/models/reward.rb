class Reward < ApplicationRecord
  belongs_to :question
  belongs_to :answer, optional: true

  has_one_attached :image

  validates :title, presence: true
  validate :validate_attached_image

  private

  def validate_attached_image
    errors.add(:image, "You must add an image file.") unless image.attached?
    errors.add(:image, "Wrong file type.") unless image.attached? && image.content_type =~ /^image/
  end
end
