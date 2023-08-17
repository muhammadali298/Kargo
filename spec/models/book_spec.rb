require 'rails_helper'

RSpec.describe Book, type: :model do

  describe 'validations' do
    it 'is valid with valid attributes' do
      book = Book.new(title: 'Sample Book', author: 'John Doe', isbn: '123456789')
      expect(book).to be_valid
    end

    it 'is not valid without a title' do
      book = Book.new(title: nil, author: 'John Doe', isbn: '123456789')
      expect(book).not_to be_valid
    end

  end
end
