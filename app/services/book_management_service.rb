# app/services/book_management_service.rb
class BookManagementService
  def initialize(book, book_params = {})
    category_names = book_params[:category_names] || []
    @book = book
    @category_names = category_names.map(&:downcase).uniq
    @book_params = book_params.except("category_names")
  end

  def create_or_update
    @book.assign_attributes(@book_params)
    update_categories_for_book
    @book.save
  end

  private

  def update_categories_for_book
    existing_category_ids = @book.category_ids

    new_category_ids = @category_names.map do |category_name|
      category = Category.find_or_create_by(name: category_name)
      category.id
    end

    categories_to_add = new_category_ids - existing_category_ids
    categories_to_remove = existing_category_ids - new_category_ids

    @book.categories << Category.find(categories_to_add) if categories_to_add.present?
    @book.categories.delete(Category.find(categories_to_remove)) if categories_to_remove.present?
  end
end