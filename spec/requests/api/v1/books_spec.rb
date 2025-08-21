require 'rails_helper'

RSpec.describe "Api::V1::Books", type: :request do
  describe "GET /index" do
    let!(:user) { FactoryBot.create(:user) }
    let!(:books) { FactoryBot.create_list(:book, 3) }
    let(:body) { JSON.parse(response.body) }

    before do 
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    end

    it "returns a successful response" do
      get api_v1_books_path
      expect(response).to have_http_status(:success)
    end

    it "returns all books" do
      get api_v1_books_path
      expect(body.size).to eq(3)
      expect(body.map { |book| book['id'] }).to match_array(books.map(&:id))
    end

    it "returns books in the correct format" do
      get api_v1_books_path
      expect(body.first).to include(
        'id', 'title', 'author', 'isbn', 'genre', 'total_copies', 'created_at', 'updated_at'
      )
    end

    context "when searching by title" do
      let(:search_query) { { title: books.first.title } }

      it "returns books matching the title" do
        get api_v1_books_path, params: search_query
        expect(response).to have_http_status(:success)
        expect(body.size).to eq(1)
        expect(body.first['title']).to eq(books.first.title)
      end
    end

    context "when searching by author" do
      let(:search_query) { { author: books.first.author } }

      it "returns books matching the author" do
        get api_v1_books_path, params: search_query
        expect(response).to have_http_status(:success)
        expect(body.size).to eq(1)
        expect(body.map { |book| book['author'] }.uniq).to eq([books.first.author])
      end
    end

    context "when searching by genre" do
      let(:search_query) { { genre: books.first.genre } }

      it "returns books matching the genre" do
        get api_v1_books_path, params: search_query
        expect(response).to have_http_status(:success)
        expect(body.size).to eq(1)
        expect(body.map { |book| book['genre'] }.uniq).to eq([books.first.genre])
      end
    end
  end

  describe "GET /show" do
    let!(:user) { FactoryBot.create(:user) }
    let!(:book) { FactoryBot.create(:book) }
    let(:body) { JSON.parse(response.body) }

    before do 
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    end

    it "returns a successful response" do
      get api_v1_book_path(book)
      expect(response).to have_http_status(:success)
    end

    it "returns the correct book" do
      get api_v1_book_path(book)
      expect(body['id']).to eq(book.id)
      expect(body['title']).to eq(book.title)
      expect(body['author']).to eq(book.author)
      expect(body['isbn']).to eq(book.isbn)
      expect(body['genre']).to eq(book.genre)
      expect(body['total_copies']).to eq(book.total_copies)
    end
  end

  describe "POST /create" do
    let(:body) { JSON.parse(response.body) }
    let(:valid_params) do
      { book: { title: "New Book", author: "New Author", isbn: "123-4567890123", genre: "Non-Fiction", total_copies: 10 } }
    end

    before do 
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    end

    context "when unauthorized user" do
      let(:user) { FactoryBot.create(:user) }
      it "returns a forbidden response" do
        post api_v1_books_path, params: valid_params
        expect(response).to have_http_status(:forbidden)
      end
    end

    context "when missing params" do
      let(:user) { FactoryBot.create(:user, :librarian) }
      it "returns an unprocessable entity response" do
        post api_v1_books_path, params: { book: { title: "" } }
        expect(response).to have_http_status(:unprocessable_content)
        expect(body['errors']).to eq ["Title can't be blank", 
          "Genre can't be blank", 
          "Author can't be blank", 
          "Isbn can't be blank", 
          "Total copies is not a number"
        ]
      end
    end

    context "when authorized user with valid params" do
      let(:user) { FactoryBot.create(:user, :librarian) }
      it "creates a new book and returns a created response" do
        expect {
          post api_v1_books_path, params: valid_params
        }.to change(Book, :count).by(1)
        expect(response).to have_http_status(:created)
        expect(body['title']).to eq("New Book")
        expect(body['author']).to eq("New Author")
        expect(body['isbn']).to eq("123-4567890123")
        expect(body['genre']).to eq("Non-Fiction")
        expect(body['total_copies']).to eq(10)
      end
    end
  end

  describe "PATCH /update" do
    let(:book) { FactoryBot.create(:book) }
    let(:body) { JSON.parse(response.body) }
    let(:valid_params) do
      { book: { title: "New Book", author: "New Author", isbn: "123-4567890123", genre: "Non-Fiction", total_copies: 10 } }
    end

    before do 
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    end

    context "when unauthorized user" do
      let(:user) { FactoryBot.create(:user) }
      
      it "returns a forbidden response" do
        patch api_v1_book_path(book), params: valid_params
        expect(response).to have_http_status(:forbidden)
      end
    end

    context "when missing params" do
      let(:user) { FactoryBot.create(:user, :librarian) }
      let(:empty_params) { { book: { title: "", genre: "", author: "", isbn: "", total_copies: "" } } }
      
      it "returns an unprocessable entity response" do
        patch api_v1_book_path(book), params: empty_params
        expect(response).to have_http_status(:unprocessable_content)
        expect(body['errors']).to eq ["Title can't be blank", 
          "Genre can't be blank", 
          "Author can't be blank", 
          "Isbn can't be blank", 
          "Total copies is not a number"
        ]
      end
    end

    context "when authorized user with valid params" do
      let(:user) { FactoryBot.create(:user, :librarian) }
      
      it "updates the book and returns a successful response" do
        patch api_v1_book_path(book), params: valid_params
        expect(response).to have_http_status(:success)
        expect(body['title']).to eq("New Book")
        expect(body['author']).to eq("New Author")
        expect(body['isbn']).to eq("123-4567890123")
        expect(body['genre']).to eq("Non-Fiction")
        expect(body['total_copies']).to eq(10)
      end
    end
  end

  describe "DELETE /destroy" do
    let(:book) { FactoryBot.create(:book) }

    before do 
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    end

    context "when unauthorized user" do
      let(:user) { FactoryBot.create(:user) }
      it "returns a forbidden response" do
        delete api_v1_book_path(book)
        expect(response).to have_http_status(:forbidden)
      end
    end

    context "when authorized user" do
      let(:user) { FactoryBot.create(:user, :librarian) }
      it "deletes the book and returns a no content response" do
        delete api_v1_book_path(book)
        expect(response).to have_http_status(:no_content)
      end
    end
  end
end
