require 'rails_helper'

RSpec.describe ReadingListExporterService, type: :service do
  let!(:reading_list) { ReadingList.create!(title: 'My Reading List') }
  let!(:book1) { Book.create!(isbn: '1234567890', title: 'Book 1', author: 'Author 1') }
  let!(:book2) { Book.create!(isbn: '0987654321', title: 'Book 2', author: 'Author 2') }

  describe '#export_to_yaml' do
    it 'exports reading list to YAML format' do
      reading_list.books << [book1, book2]
      exporter = ReadingListExporterService.new(reading_list)
      yaml_data = exporter.export_to_yaml

      expected_yaml = {
        id: reading_list.id,
        title: reading_list.title,
        books: [
          { isbn: book1.isbn, title: book1.title, author: book1.author },
          { isbn: book2.isbn, title: book2.title, author: book2.author }
        ]
      }.to_yaml

      expect(yaml_data).to eq(expected_yaml)
    end
  end

  describe '#export_to_pantry' do
    it 'exports reading list to Pantry' do
      reading_list.books << [book1, book2]
      pantry_id = 'your_pantry_id'
      basket_name = 'your_basket_name'

      exporter = ReadingListExporterService.new(reading_list)
      allow(HTTParty).to receive(:post).and_return(double(success?: true))

      export_successful = exporter.export_to_pantry(pantry_id, basket_name)

      expect(export_successful).to be(true)
    end

    it 'returns false if export to Pantry fails' do
      reading_list.books << [book1, book2]
      pantry_id = 'your_pantry_id'
      basket_name = 'your_basket_name'

      exporter = ReadingListExporterService.new(reading_list)
      allow(HTTParty).to receive(:post).and_return(double(success?: false))

      export_successful = exporter.export_to_pantry(pantry_id, basket_name)

      expect(export_successful).to be(false)
    end
  end
end
