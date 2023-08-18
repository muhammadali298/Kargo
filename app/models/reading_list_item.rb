class ReadingListItem < ApplicationRecord
  belongs_to :book
  belongs_to :reading_list

  validates :book_id, uniqueness: { scope: :reading_list_id, message: "This book is already in the reading list." }

  enum status: {
    unread: 'unread',
    in_progress: 'in progress',
    finished: 'finished'
  }

  before_validation :set_default_status

  private

  def set_default_status
    self.status ||= :unread
  end
end
