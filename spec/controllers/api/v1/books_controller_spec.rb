require 'rails_helper'

RSpec.describe Api::V1::BooksController, type: :controller do
  describe 'GET #index' do
    it 'returns a successful response' do
      get :index, format: :json
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    let(:book) { Book.create(isbn: 'example_isbn', title: 'Example Title', author: 'Example Author') }

    it 'returns a successful response' do
      get :show, params: { id: book.id }, format: :json
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    let(:book_params) do
      {
        isbn: 'example_isbn',
        title: 'Example Title',
        author: 'Example Author',
        category_names: ['Category 1', 'Category 2']
      }
    end

    it 'creates a new book' do
      expect {
        post :create, params: { book: book_params }, format: :json
      }.to change(Book, :count).by(1)
      expect(response).to have_http_status(:created)
    end

    it 'returns validation errors if book creation fails' do
      post :create, params: { book: { isbn: 'example_isbn' } }, format: :json
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include('can\'t be blank')
    end
  end

  describe 'PUT #update' do
    let(:book) { Book.create(isbn: 'example_isbn', title: 'Example Title', author: 'Example Author') }
    let(:updated_params) { { title: 'Updated Title' } }

    it 'updates the book' do
      put :update, params: { id: book.id, book: updated_params }, format: :json
      expect(book.reload.title).to eq('Updated Title')
      expect(response).to be_successful
    end

    it 'returns validation errors if update fails' do
      put :update, params: { id: book.id, book: { title: '' } }, format: :json
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include('can\'t be blank')
    end
  end

  describe 'DELETE #destroy' do
    let!(:book) { Book.create(isbn: 'example_isbn', title: 'Example Title', author: 'Example Author') }

    it 'destroys the book' do
      expect {
        delete :destroy, params: { id: book.id }, format: :json
      }.to change(Book, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end
