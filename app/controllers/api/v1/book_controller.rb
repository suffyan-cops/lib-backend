module Api
  module V1
    class BookController < ApplicationController
        before_action  :unauthorized_access

          # GET /books/count
          def fetchBookCount
            if current_user.role =='super_admin'
              book = Book.all.count
            else
              book = Book.where(library_id: current_user.library_id).count
            end
             render json: book, status: :ok
          end

          # GET /books/available_count
          def fetchAvailableBooksCount
             if current_user.role =='super_admin'
              book=Book.available_book_count_for_admin
             elsif current_user.role == 'reader'
                book = Book.where(library_id: current_user.library_id).count
             end
             render json: book, status: :ok
          end

          # GET /books/user/:id
          def getBooksAgainstUserLibrary
            user = User.find_by(id: params[:id])
            if user
              books = Book.get_book_against_user_id(user.library_id)
              render json: books, status: :ok
            else
              render json: { error: 'User not found' }, status: :not_found
            end
          end


          # GET /books
          def index
             if current_user.role == 'super_admin'
                @books = Book.with_library_name
             else 
                @books  = Book.by_user_library(current_user.library_id)
             end
            render json: @books
          end

           # POST /books
          def create
            # challenge = Challenge.new(title:"Lorem Ipsum 2", description:"Random Description2", start_date:Date.today, end_date:Date.tomorrow)
            book = Book.new(book_params)
            book.created_by = current_user.id
            if book.save
              render json: {message: "Data Succesfully added!", data: book}
            else
              render json: {message: "Failed To Add Book!", data: book.errors}, status: :unprocessable_entity
            end

          end

          # GET /books/:id
          def show
              book = Book.find(params[:id])
              if book
                render json: {message: "Data Found!", result: book}
              else
                render json: {message:"Data Not Found!", result: book.errors}
              end
          end
        
          # PUT /books/:id
          def update
            book = Book.find(params[:book][:id])
          

            if book.update(book_params)
              render json: {message: "Data Updated Successfully", result: book}
            else
              render json: {message: "Data not updated", result: book.errors}, status: :unprocessable_entity
            end
          end

          # DELETE /books/:id

          def destroy
            book = Book.find(params[:book][:id])
            if book.destroy
              render json: {message:"Data Deleted Successfully!", result: book}
            else
              render json: {message:"Data not Deleted", result: book.errors}
            end

          end

          # GET /books/search
          def search 
            query = params[:searchValue]
            # book = Book.where("title ILIKE? ", "%#{query}%")

           if current_user.role == 'super_admin'
              @books = Book.search_for_admin(query)
           else 
              @books  = Book.where(library_id: current_user.library_id).where("books.title ILIKE? ", "%#{query}%").joins(:library).select('books.*, libraries.name as library_name') 
           end
            render json: @books, status: :ok
          end

          # GET /books/library/:library_id
          def get_books_by_library_id
            library_id = params[:library_id]
            if library_id
              books = Book.where(library_id: library_id).joins(:library).select('books.*, libraries.name as library_name')
              render json: books, status: :ok
            else
              render json: {error: 'Library not found' }, status: :not_found
            end
          end

          # GET /books/return_dates
          def fetchBooksWithReturnDate
            query = params[:book_id]
            request =  Request.joins(:user, :book).where(book_id: query, status:1).where(users: { role: 2 }).select('requests.*, users.name AS user_name, users.email AS user_email, books.title AS book_title')
            render json: request, status: :ok
          end

          def unauthorized_access
            render json: { error: 'Unauthorized access' }, status: :unauthorized unless current_user.present?
          end

          private
          def book_params
              params.require(:book).permit(:title, :description, :quantity, :publication_year, :library_id)
          end
    end
  end
end