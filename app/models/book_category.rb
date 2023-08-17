class BookCategory < ApplicationRecord
  belongs_to :book
  belongs_to :category

  validates :book_id, uniqueness: { scope: :category_id, message: "has already been added to this category" }
end
