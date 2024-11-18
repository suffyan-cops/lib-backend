module Api
  module V1
    class RequestController < ApplicationController
        before_action  :unauthorized_access
        # before_action :authorize_admin , only: %i[create update destroy]
           # before_action :set_challenge, only%i[show,update,destroy]


           def issuedBooksCount
            if current_user.role =='super_admin'
              issued_books_count = Request.joins(:book).where(requests: { status: 'Completed' }).count
            elsif current_user.role == 'librarian'
              issued_books_count = Request.joins(:book).where(requests: { status: 'Completed' }).where(books: { library_id: current_user.library_id }).distinct.count(:book_id)
            else
              issued_books_count = Request.joins(:book).where(requests: { status: 'Completed', user_id: current_user.id  }).where(books: { library_id: current_user.library_id }).distinct.count(:book_id)
            end
             render json: issued_books_count, status: :ok
           end

          def index
            select_fields = 'requests.*, books.title AS book_name, users.name AS user_name, requests.status, requests.returned_date'
            if current_user.role == "super_admin"
              requests = Request.joins(:book, :user)
                                .select(select_fields)
            elsif current_user.role == "reader"
              requests = Request.joins(:book, :user)
                                .where(requests: {  user_id: current_user.id })
                                .select(select_fields)
            else
              requests = Request.joins(:book, :user)
                                .where(users: { library_id: current_user.library_id })
                                .select(select_fields)
            end
            render json: requests
          end

          def create
            # challenge = Challenge.new(title:"Lorem Ipsum 2", description:"Random Description2", start_date:Date.today, end_date:Date.tomorrow)
            puts '**************************************'
            puts request_params[:status]
            book_id= request_params[:book_id]
            book = Book.find_by(id: book_id )
            puts book.inspect
            if request_params[:status]!='Rejected'
              book.quantity = (book.quantity.to_i - 1).to_s
              book.save
            end
          
            request = Request.new(request_params)
            request.created_by = current_user.id
            if request.save
              render json: {message: "Data Succesfully added!", data: request}
            else
              render json: {message: "Failed To Add Book!", data: request.errors}, status: :unprocessable_entity
            end

          end

          def show
            request = Request.find(params[:id])
              if request
                render json: {message: "Data Found!", result: request}
              else
                render json: {message:"Data Not Found!", result: request.errors}
              end
          end

          def update
            p "*************************************"
            request = Request.find(params[:request][:id])

            if request.update(request_params)
              render json: {message: "Data Updated Successfully", result: request}
            else
              render json: {message: "Data not updated", result: request.errors}, status: :unprocessable_entity
            end
          end

          def destroy

            request = Request.find(params[:request][:id])
            book = Book.find_by(id: request.book_id )
            book.quantity = (book.quantity.to_i + 1).to_s
            book.save
            if request.destroy
              render json: {message:"Data Deleted Successfully!", result: request}
            else
              render json: {message:"Data not Deleted", result: request.errors}
            end

          end

          def search 
            select_fields = 'requests.*, books.title AS book_name, users.name AS user_name, requests.status, requests.returned_date'
            statuses = ['submitted', 'completed', 'rejected']
            query = params[:searchValue]&.strip&.downcase
            puts "query #{query}"
        
            if query.present? && statuses.include?(query)
              puts query
              status_index = statuses.index(query)
            else
              status_index = nil
            end

            puts query
            if  query.blank?
              if current_user.role == "super_admin"
                requests = Request.joins(:book, :user)
                                  .select(select_fields)
                                  render json: requests, status: :ok
              elsif current_user.role == "reader"
                     puts "readers1234 #{current_user.inspect}"
                requests = Request.joins(:book, :user)
                                  .where(requests: {  user_id: current_user.id })
                                  .select(select_fields)
                                  render json: requests, status: :ok

              else
                puts "sdfdsfds"
                requests = Request.joins(:book, :user)
                                  .where(users: { library_id: current_user.library_id })
                                  .select(select_fields)
                render json: requests, status: :ok
              end

            elsif status_index.nil?
              render json: { error: "Type a correct complete status name" }, status: :not_found
            else
              if current_user.role != "reader"
              request = Request.joins(:book, :user).where(status: status_index).select(select_fields)
              render json: request, status: :ok
              else
                request = Request.joins(:book, :user).where(status: status_index).where(requests: {  user_id: current_user.id }).select(select_fields)
                render json: request, status: :ok
              end
            end
            # render json: request, status: :ok
          end


          private
          def request_params
              params.require(:request).permit(:book_id, :user_id, :status, :returned_date)
          end

          def unauthorized_access
            render json: { error: 'Unauthorized access' }, status: :unauthorized unless current_user.present?
          end


          def authorize_admin
            unless current_user.email == "admin@example.com"
              render json: {message: "Unauthorized Access!"}
            end
          end
    end
  end
end