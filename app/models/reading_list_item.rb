class ReadingListItem < ApplicationRecord
  belongs_to :book
  belongs_to :reading_list

  validates :book_id, uniqueness: { scope: :reading_list_id, message: "This book is already in the reading list." }

  enum status: {
    unread: 'unread',
    in_progress: 'in progress',
    finished: 'finished'
  }

  after_create :set_default_status

  private

  def set_default_status
    update(status: :unread)
  end
end
