class ReadingList < ApplicationRecord
  has_many :reading_list_items, dependent: :destroy
  has_many :books, through: :reading_list_items


  validates :title, presence: true, uniqueness: true
end
