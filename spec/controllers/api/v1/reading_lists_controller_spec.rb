require 'rails_helper'

RSpec.describe Api::V1::ReadingListsController, type: :controller do

  describe 'GET #index' do
    let!(:reading_list1) { ReadingList.create!(title: 'Reading List 1') }
    let!(:reading_list2) { ReadingList.create!(title: 'Reading List 2') }

    before do
      get :index, format: :json
    end

    it 'returns a success response' do
      expect(response).to have_http_status(:success)
    end

    it 'assigns all reading lists to @reading_lists' do
      parsed_response = JSON.parse(response.body)
      expect(parsed_response.size).to eq(2)
      expect(parsed_response).to eq([{"books"=>[], "id"=>1, "title"=>"Reading List 1"}, {"books"=>[], "id"=>2, "title"=>"Reading List 2"}])
    end
  end

  describe 'GET #show' do
    let(:reading_list) { ReadingList.create!(title: 'My Reading List') }
    before do
      get :show, params: { id: reading_list.id }, format: :json
    end

    it 'returns a success response' do
      expect(response).to have_http_status(:success)
    end

    it 'returns the reading list data' do
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['id']).to eq(reading_list.id)
      expect(parsed_response['title']).to eq(reading_list.title)
    end

    context 'when there are books in the reading list' do
      let(:book1) { Book.create!(isbn: '1234567890', title: 'Book Title 1', author: 'Author 1') }
      let(:book2) { Book.create!(isbn: '9876543210', title: 'Book Title 2', author: 'Author 2') }

      before do
        reading_list.books << [book1, book2]
        get :show, params: { id: reading_list.id }, format: :json
      end

      it 'returns the reading list data along with books' do
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['books'].size).to eq(2)
        expect(parsed_response['books'][0]['id']).to eq(book1.id)
        expect(parsed_response['books'][0]['isbn']).to eq(book1.isbn)
        expect(parsed_response['books'][0]['title']).to eq(book1.title)
        expect(parsed_response['books'][0]['author']).to eq(book1.author)
      end
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      let(:valid_attributes) { { title: 'My Reading List' } }

      it 'creates a new reading list' do
        expect {
          post :create, params: { reading_list: valid_attributes }, format: :json
        }.to change(ReadingList, :count).by(1)
      end

      it 'returns a success response with the new reading list' do
        post :create, params: { reading_list: valid_attributes }, format: :json
        parsed_response = JSON.parse(response.body)
        expect(response).to have_http_status(:created)
        expect(parsed_response['title']).to eq('My Reading List')
      end
    end

    context 'with invalid params' do
      let(:invalid_attributes) { { title: '' } }

      it 'does not create a new reading list' do
        expect {
          post :create, params: { reading_list: invalid_attributes }, format: :json
        }.not_to change(ReadingList, :count)
      end

      it 'returns an error response' do
        post :create, params: { reading_list: invalid_attributes }, format: :json
        parsed_response = JSON.parse(response.body)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(parsed_response['title']).to include("can't be blank")
      end
    end
  end

  describe 'PATCH #update' do
    let(:reading_list) { ReadingList.create!(title: 'Original Title') }

    context 'with valid params' do
      let(:new_attributes) { { title: 'Updated Title' } }

      it 'updates the requested reading list' do
        patch :update, params: { id: reading_list.id, reading_list: new_attributes }, format: :json
        reading_list.reload
        expect(reading_list.title).to eq('Updated Title')
      end

      it 'returns a success response with the updated reading list' do
        patch :update, params: { id: reading_list.id, reading_list: new_attributes }, format: :json
        parsed_response = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(parsed_response['title']).to eq('Updated Title')
      end
    end

    context 'with invalid params' do
      let(:invalid_attributes) { { title: '' } }

      it 'does not update the reading list' do
        patch :update, params: { id: reading_list.id, reading_list: invalid_attributes }, format: :json
        reading_list.reload
        expect(reading_list.title).to eq('Original Title')
      end

      it 'returns an error response' do
        patch :update, params: { id: reading_list.id, reading_list: invalid_attributes }, format: :json
        parsed_response = JSON.parse(response.body)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(parsed_response['title']).to include("can't be blank")
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:reading_list) { ReadingList.create!(title: 'My Reading List') }

    it 'destroys the requested reading list' do
      expect {
        delete :destroy, params: { id: reading_list.id }, format: :json
      }.to change(ReadingList, :count).by(-1)
    end

    it 'returns a success response with no_content' do
      delete :destroy, params: { id: reading_list.id }, format: :json
      expect(response).to have_http_status(:no_content)
    end
  end

  describe 'PATCH #update_book' do
    let!(:reading_list) { ReadingList.create!(title: 'My Reading List') }
    let!(:book) { Book.create!(isbn: '1234567890', title: 'Book Title', author: 'Book Author') }

    it 'updates the status of books in the reading list' do
      reading_list.books << book
      patch :update_book, params: { id: reading_list.id, book_id: book.id, status: 'in progress' }, format: :json
      book.reload
      expect(book.reading_list_items.first.status).to eq('in_progress')
    end

    it 'returns a success response with updated status' do
      reading_list.books << book
      patch :update_book, params: { id: reading_list.id, book_id: book.id, status: 'finished' }, format: :json
      parsed_response = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(parsed_response['books'].first['status']).to eq('finished')
    end
  end

  describe 'POST #add_books' do
    let!(:reading_list) { ReadingList.create!(title: 'My Reading List') }
    let!(:book1) { Book.create!(isbn: '1234567890', title: 'Book 1', author: 'Author 1') }
    let!(:book2) { Book.create!(isbn: '0987654321', title: 'Book 2', author: 'Author 2') }

    it 'adds books to the reading list' do
      post :add_books, params: { id: reading_list.id, book_ids: [book1.id, book2.id] }, format: :json
      reading_list.reload
      expect(reading_list.books).to include(book1, book2)
    end

    it 'returns a success response with updated reading list' do
      post :add_books, params: { id: reading_list.id, book_ids: [book1.id, book2.id] }, format: :json
      parsed_response = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(parsed_response['books'].size).to eq(2)
    end
  end

  describe 'POST #remove_books' do
    let!(:reading_list) { ReadingList.create!(title: 'My Reading List') }
    let!(:book1) { Book.create!(isbn: '1234567890', title: 'Book 1', author: 'Author 1') }
    let!(:book2) { Book.create!(isbn: '0987654321', title: 'Book 2', author: 'Author 2') }

    before do
      reading_list.books << [book1, book2]
    end

    it 'removes books from the reading list' do
      post :remove_books, params: { id: reading_list.id, book_ids: [book1.id] }, format: :json
      reading_list.reload
      expect(reading_list.books).to eq([book2])
    end

    it 'returns a success response with updated reading list' do
      post :remove_books, params: { id: reading_list.id, book_ids: [book1.id] }, format: :json
      parsed_response = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(parsed_response['books'].size).to eq(1)
    end
  end
end