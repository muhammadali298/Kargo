require 'rails_helper'

RSpec.describe BookCategory, type: :model do

  describe 'validations' do
    let(:book) { Book.create(isbn: '123456789', title: 'Sample Book', author: 'John Doe') }
    let(:category) { Category.create(name: 'Science Fiction') }
    let!(:book_category) { BookCategory.create(book: book, category: category) }
    
    it 'validates uniqueness of book_id scoped to category_id' do
      duplicate_category = BookCategory.new(book: book_category.book, category: book_category.category)

      expect(duplicate_category).not_to be_valid
      expect(duplicate_category.errors[:book_id]).to include('has already been added to this category')
    end
  end
end
