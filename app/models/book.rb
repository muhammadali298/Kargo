class Book < ApplicationRecord
  has_many :reading_list_items
  has_many :reading_lists, through: :reading_list_items
  
  validates :isbn, presence: true
  validates :title, presence: true
  validates :author, presence: true
end
