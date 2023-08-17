require 'rails_helper'

RSpec.describe ReadingListItem, type: :model do
  let(:book) { Book.create(isbn: 'example_isbn', title: 'Example Title', author: 'Example Author') }
  let(:reading_list) { ReadingList.create(title: 'Example Reading List') }
  let!(:reading_list_item) { ReadingListItem.create(book: book, reading_list: reading_list) }

  describe 'validations' do
    it 'validates uniqueness of book_id scoped to reading_list_id' do
      new_reading_list_item = ReadingListItem.new(book: book, reading_list: reading_list)
      expect(new_reading_list_item).not_to be_valid
      expect(new_reading_list_item.errors[:book_id]).to include('This book is already in the reading list.')
    end
  end

  it 'defines enum values' do
    expect(ReadingListItem.statuses[:unread]).to eq('unread')
    expect(ReadingListItem.statuses[:in_progress]).to eq('in progress')
    expect(ReadingListItem.statuses[:finished]).to eq('finished')
  end

  describe 'callbacks' do
    it 'sets default status to unread after creation' do
      expect(reading_list_item.status).to eq('unread')
    end
  end
end
