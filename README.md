# Kargo

This manages reading list.

## Setup

- Ruby version: ruby-2.7.4
- Rails version: Rails 7.0.7

## How to Run

To run the test suite, follow these steps:

1. Install the required dependencies:

   ```sh
   bundle install

2. DB migration

    ```sh
    rake db:create
    rake db:migrate

3. Run the tests

    ```sh
    bundle exec rspec

4. Run server

    ```sh
    rails s

## POSTMAN Collection
- Postman collection `ReadingList API.postman_collection.json`of the API is attached in root directory of the code. That can be used to interact with the API

## Category Feature
- A book can have many categories and a category can be associated with many books. When the Book is create or updated we can also pass the array `category_names`. Those categories will be assigned to book. If the Category is not in the DB it will create it otherwise it will find the category with the name and assign it to book.