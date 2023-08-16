json.array!(@reading_lists) do |reading_list|
  json.partial! 'reading_list', reading_list: reading_list
end