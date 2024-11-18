module Api
  module V1
    class BookController < ApplicationController
        before_action  :unauthorized_access
        # before_action :authorize_admin , only: %i[create update destroy]
           # before_action :set_challenge, only%i[show,update,destroy]
           # 

           def fetchBookCount
            if current_user.role =='super_admin'
              book = Book.all.count
            else
              book = Book.where(library_id: current_user.library_id).count
            end
             render json: book, status: :ok
           end

           def fetchAvailableBooksCount
             if current_user.role =='super_admin'
              book=Book.left_joins(:request).where('requests.status IS NULL OR requests.status != 1').distinct.count
             elsif current_user.role == 'reader'
                # book=Book.left_joins(:request).where('requests.status IS NULL OR requests.status != 1').where(books: {library_id: current_user.library_id}).distinct.count
                book = Book.where(library_id: current_user.library_id).count

             end

             render json: book, status: :ok
           end

          def getBooksAgainstUserLibrary
            user = User.find_by(id: params[:id])
            if user
              books = Book.joins(:library)
                          .where(library_id: user.library_id)
                          .where('CAST(books.quantity AS INTEGER) > ?', 0)
                          .select('books.*, libraries.name as library_name')
              render json: books, status: :ok
            else
              render json: { error: 'User not found' }, status: :not_found
            end
          end



          def index
            # @book = Book.includes(:library).all
             if current_user.role == 'super_admin'
                @books = Book.with_library_name
             else 
                @books  = Book.by_user_library(current_user.library_id)
             end
            # render json: @book.as_json(include: :library)
            render json: @books
          end

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

          def show
              book = Book.find(params[:id])
              if book
                render json: {message: "Data Found!", result: book}
              else
                render json: {message:"Data Not Found!", result: book.errors}
              end
          end

          def update
            book = Book.find(params[:book][:id])
          

            if book.update(book_params)
              render json: {message: "Data Updated Successfully", result: book}
            else
              render json: {message: "Data not updated", result: book.errors}, status: :unprocessable_entity
            end
          end

          def destroy
            book = Book.find(params[:book][:id])
            if book.destroy
              render json: {message:"Data Deleted Successfully!", result: book}
            else
              render json: {message:"Data not Deleted", result: book.errors}
            end

          end

          def search 
            query = params[:searchValue]
            # book = Book.where("title ILIKE? ", "%#{query}%")

           if current_user.role == 'super_admin'
              @books = Book.joins(:library).where("books.title ILIKE? ", "%#{query}%").select('books.*, libraries.name as library_name')
           else 
              @books  = Book.where(library_id: current_user.library_id).where("books.title ILIKE? ", "%#{query}%").joins(:library).select('books.*, libraries.name as library_name') 
           end
            render json: @books, status: :ok
          end


          def get_books_by_library_id
            library_id = params[:library_id]
            if library_id
              books = Book.where(library_id: library_id).joins(:library).select('books.*, libraries.name as library_name')
              render json: books, status: :ok
            else
              render json: {error: 'Library not found' }, status: :not_found
            end
          end



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

          # def authorize_admin
          #   unless current_user.email == "admin@example.com"
          #     render json: {message: "Unauthorized Access!"}
          #   end
          # end
    end
  end
end