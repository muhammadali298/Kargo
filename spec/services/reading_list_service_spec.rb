require 'rails_helper'

RSpec.describe ReadingListService, type: :service do
  let!(:reading_list) { ReadingList.create!(title: 'My Reading List') }
  let!(:book1) { Book.create!(isbn: '1234567890', title: 'Book 1', author: 'Author 1') }
  let!(:book2) { Book.create!(isbn: '0987654321', title: 'Book 2', author: 'Author 2') }
  let!(:book3) { Book.create!(isbn: '5555555555', title: 'Book 3', author: 'Author 3') }

  describe '#add_books' do
    before do
      reading_list.books << book1
    end

    it 'adds new books to the reading list' do
      service = ReadingListService.new(reading_list)
      service.book_ids = [book2.id, book3.id]

      expect {
        result = service.add_books
        expect(result[:success]).to be(true)
      }.to change(reading_list.books, :count).by(2)
    end

    it 'returns success even if no new books are added' do
      service = ReadingListService.new(reading_list)
      service.book_ids = [book1.id, book2.id]

      result = service.add_books
      expect(result[:success]).to be(true)
    end

    it 'returns error if an exception occurs' do
      allow(reading_list.books).to receive(:<<).and_raise('Some error')
      service = ReadingListService.new(reading_list)
      service.book_ids = [book2.id, book3.id]

      result = service.add_books
      expect(result[:success]).to be(false)
      expect(result[:error]).to eq('Some error')
    end
  end

  describe '#remove_books' do
    before do
      reading_list.books << [book1, book2, book3]
    end

    it 'removes books from the reading list' do
      service = ReadingListService.new(reading_list)
      service.book_ids = [book1.id, book2.id]

      expect {
        result = service.remove_books
        expect(result[:success]).to be(true)
      }.to change(reading_list.books, :count).by(-2)
    end

    it 'returns success even if no books are removed' do
      service = ReadingListService.new(reading_list)
      service.book_ids = []

      result = service.remove_books
      expect(result[:success]).to be(true)
    end

    it 'returns error if an exception occurs' do
      allow(reading_list.books).to receive(:destroy).and_raise('Some error')
      service = ReadingListService.new(reading_list)
      service.book_ids = [book2.id, book3.id]

      result = service.remove_books
      expect(result[:success]).to be(false)
      expect(result[:error]).to eq('Some error')
    end
  end
end
