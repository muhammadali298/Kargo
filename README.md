# Kargo

This manages reading list.

## Table of Contents

- [Setup](#setup)
- [How to Run](#how-to-run)

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

Postman collection of the API is attached in root directory of the code. That can be used to interact with the API