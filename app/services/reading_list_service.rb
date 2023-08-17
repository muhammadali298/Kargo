class ReadingListService
  attr_reader :reading_list
  attr_accessor :book_ids

  def initialize(reading_list)
    @reading_list = reading_list
  end

  def add_books
    begin
      books_to_add = Book.where(id: book_ids).where.not(id: reading_list.books.pluck(:id))
      reading_list.books << books_to_add
    rescue => e
      return { success: false, error: e.message }
    end

    { success: true }
  end

  def remove_books
    begin
      books_to_remove = Book.where(id: book_ids)
      reading_list.books.destroy(books_to_remove)
    rescue => e
      return { success: false, error: e.message }
    end

    { success: true }
  end
end
