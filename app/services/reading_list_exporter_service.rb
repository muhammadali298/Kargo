class ReadingListExporterService
  def initialize(reading_list)
    @reading_list = reading_list
  end

  def export_to_yaml
    reading_list_data = generate_reading_list_data
    reading_list_data.to_yaml
  end

  def export_to_pantry(pantry_id, basket_name)
    reading_list_data = generate_reading_list_data
    url = "https://getpantry.cloud/apiv1/pantry/#{pantry_id}/basket/#{basket_name}"

    headers = {
      'Content-Type' => 'application/json'
    }

    response = HTTParty.post(url, headers: headers, body: reading_list_data.to_json)

    response.success?
  end

  private

  def generate_reading_list_data
    {
      id: @reading_list.id,
      title: @reading_list.title,
      books: @reading_list.books.map { |book| { isbn: book.isbn, title: book.title, author: book.author } }
    }
  end
end