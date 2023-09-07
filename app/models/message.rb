class Message < ApplicationRecord
  belongs_to :member
  belongs_to :room

  validates :message, length: {  maximum: 100 }, presence: true
end
