class Book < ApplicationRecord
  has_many :reading_list_items
  has_many :reading_lists, through: :reading_list_items
  has_many :book_categories
  has_many :categories, through: :book_categories
  
  validates :isbn, presence: true
  validates :title, presence: true
  validates :author, presence: true
end
