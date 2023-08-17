class Api::V1::ReadingListsController < ApplicationController
  before_action :set_reading_list, only: [:show, :update, :destroy, :add_books, :remove_books, :update_book, :export_to_yaml, :export_to_pantry]

  def index
    @reading_lists = ReadingList.includes(:books, :reading_list_items).all
    render :index
  end

  def show
    render_show_response
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

  def remove_books
    service = ReadingListService.new(@reading_list)
    service.book_ids = params[:book_ids]
    result = service.remove_books

    if result[:success]
      render_show_response
    else
      render json: { error: result[:error] }, status: :unprocessable_entity
    end
  end

  def add_books
    service = ReadingListService.new(@reading_list)
    service.book_ids = params[:book_ids]
    result = service.add_books

    if result[:success]
      render_show_response
    else
      render json: { error: result[:error] }, status: :unprocessable_entity
    end
  end

  def update_book
    book = Book.find(params[:book_id])
    new_status = params[:status]
  
    book.reading_list_items.each do |reading_list_item|
      reading_list_item.update(status: new_status)
    end
  
    render_show_response
  end

  def export_to_yaml
    exporter = ReadingListExporterService.new(@reading_list)
    yaml_data = exporter.export_to_yaml

    render json: { yaml: yaml_data }
  end

  def export_to_pantry
    pantry_id = params[:pantry_id]
    basket_name = params[:basket_name]
    exporter = ReadingListExporterService.new(@reading_list)
    export_successful = exporter.export_to_pantry(pantry_id, basket_name)

    if export_successful
      render json: { message: "Reading list successfully exported to Pantry basket #{basket_name}" }
    else
      render json: { message: "Failed to export reading list to Pantry basket #{basket_name}" }, status: :unprocessable_entity
    end
  end

  private

  def render_show_response
    sort_by = params[:sort_by]
    sort_type = params[:sort_type] == 'desc' ? :desc : :asc
    @books = sort_books(@reading_list.books, sort_by, sort_type)

    render :show
  end

  def sort_books(books, sort_by, sort_type)
    if sort_by.present? && Book.column_names.include?(sort_by)
      books.order("#{sort_by} #{sort_type}")
    else
      books
    end
  end

  def set_reading_list
    @reading_list = ReadingList.includes(:books, :reading_list_items).find(params[:id])
  end

  def reading_list_params
    params.require(:reading_list).permit(:title)
  end
end
