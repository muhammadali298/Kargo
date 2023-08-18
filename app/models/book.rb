class Book < ApplicationRecord
  has_many :reading_list_items, dependent: :destroy
  has_many :reading_lists, through: :reading_list_items
  has_many :book_categories, dependent: :destroy
  has_many :categories, through: :book_categories
  
  validates :isbn, presence: true, uniqueness: true
  validates :title, presence: true
  validates :author, presence: true
end
