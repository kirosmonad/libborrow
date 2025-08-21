class Api::V1::BooksController < ApplicationController
  def index
    authorize Book
    @books = BookQuery.new.search(params)
    render :index, format: :json
  end

  def show
    authorize Book
    @book = Book.find(params[:id])
    render :show, format: :json
  end

  def create
    @book = Book.new(book_params)
    authorize @book
    if @book.save
      render :show, format: :json, status: :created
    else
      render json: { errors: @book.errors.full_messages }, status: :unprocessable_content
    end
  end

  def update
    @book = Book.find(params[:id])
    authorize @book
    if @book.update(book_params)
      render :show, format: :json
    else
      render json: { errors: @book.errors.full_messages }, status: :unprocessable_content
    end
  end

  def destroy
    @book = Book.find(params[:id])
    authorize @book
    @book.destroy
    head :no_content
  end

  private

  def book_params
    params.require(:book).permit(:title, :author, :isbn, :genre, :total_copies)
  end
end
