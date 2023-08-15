class ReadingListItem < ApplicationRecord
  belongs_to :book
  belongs_to :reading_list

  enum status: {
    unread: 'unread',
    in_progress: 'in progress',
    finished: 'finished'
  }
end
