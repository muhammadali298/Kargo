require 'rails_helper'

RSpec.describe BookManagementService, type: :service do
  let(:book) { Book.new }
  let(:book_params) { { isbn: '1234567890', title: 'Book Title', author: 'Book Author', category_names: ['Category 1', 'Category 2'] } }

  describe '#initialize' do
    it 'initializes with correct instance variables' do
      service = BookManagementService.new(book, book_params)

      expect(service.instance_variable_get(:@book)).to eq(book)
      expect(service.instance_variable_get(:@category_names)).to eq(['category 1', 'category 2'])
    end

    it 'handles missing category_names in params' do
      service = BookManagementService.new(book, isbn: '1234567890', title: 'Book Title', author: 'Book Author')

      expect(service.instance_variable_get(:@book)).to eq(book)
      expect(service.instance_variable_get(:@category_names)).to eq([])
    end
  end
end
