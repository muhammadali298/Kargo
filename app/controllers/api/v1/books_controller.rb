class Api::V1::BooksController < ApplicationController
  before_action :set_book, only: [:show, :update, :destroy]

  def index
    @books = Book.includes(:categories)
    render :index
  end

  def show
    render :show
  end

  def create
    @book = Book.new
    service = BookManagementService.new(@book, book_params)
    service.create_or_update

    if @book.errors.empty?
      render :create, status: :created
    else
      render json: @book.errors, status: :unprocessable_entity
    end
  end

  def update
    service = BookManagementService.new(@book, book_params)
    service.create_or_update

    if @book.errors.empty?
      render :update
    else
      render json: @book.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @book.destroy
    head :no_content
  end

  private

  def set_book
    @book = Book.includes(:categories).find(params[:id])
  end

  def book_params
    permitted_params = params.require(:book).permit(:isbn, :title, :author)
    category_names = Array(params[:category_names])
    permitted_params.merge(category_names: category_names)
  end
end
