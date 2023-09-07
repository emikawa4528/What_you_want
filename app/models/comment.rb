class Comment < ApplicationRecord
  belongs_to :idea
  belongs_to :member

  validates :comment, length: {  maximum: 100 }, presence: true
end
