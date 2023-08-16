class Api::V1::ReadingListsController < ApplicationController
  before_action :set_reading_list, only: [:show, :update, :destroy, :add_books, :remove_books, :update_book]

  def index
    @reading_lists = ReadingList.includes(:books, :reading_list_items).all
    render :index
  end

  def show
    render :show
  end

  def create
    @reading_list = ReadingList.new(reading_list_params)
    if @reading_list.save
      render :create, status: :created
    else
      render json: @reading_list.errors, status: :unprocessable_entity
    end
  end

  def update
    if @reading_list.update(reading_list_params)
      render :update
    else
      render json: @reading_list.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @reading_list.destroy
    head :no_content
  end

  def add_books
    book_ids = params[:book_ids]
    books_to_add = Book.where(id: book_ids)
    @reading_list.books << books_to_add
    render :show
  end

  def remove_books
    book_ids = params[:book_ids]
    books_to_remove = Book.where(id: book_ids)
    @reading_list.books.destroy(books_to_remove)
    render :show
  end

  def update_book
    book = Book.find(params[:book_id])
    new_status = params[:status]
  
    book.reading_list_items.each do |reading_list_item|
      reading_list_item.update(status: new_status)
    end
  
    render :show
  end

  private

  def set_reading_list
    @reading_list = ReadingList.includes(:books, :reading_list_items).find(params[:id])
  end

  def reading_list_params
    params.require(:reading_list).permit(:title)
  end
end
