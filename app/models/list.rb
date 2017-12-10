class List < ApplicationRecord
  has_many :cards, ->{ order(position: :asc)}, dependent: :destroy

  acts_as_list

  scope :sorted, ->{ order(position: :asc)} 
  validates :name, presence: true
end
