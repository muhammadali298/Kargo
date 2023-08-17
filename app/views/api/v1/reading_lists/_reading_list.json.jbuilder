json.id reading_list.id
json.title reading_list.title
json.books books do |book|
  json.id book.id
  json.isbn book.isbn
  json.title book.title
  json.author book.author
  json.status book.reading_list_items.find_by(reading_list: reading_list).status
end