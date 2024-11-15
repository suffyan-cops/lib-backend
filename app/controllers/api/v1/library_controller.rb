module Api
  module V1
    class LibraryController < ApplicationController
        before_action  :authenticate_user!
        # before_action :authorize_admin , only: %i[create update destroy]
           # before_action :set_challenge, only%i[show,update,destroy]
           # 
          
           def fetchLibCount
              library = Library.all.count
           
             render json: library, status: :ok
           end


           def fetchLibraryCount
            if current_user.role =='super_admin'
              library = User.where(role: 'librarian').all.count
            else
              library = User.where(role: 'librarian').where.not(id: current_user.id).where(library_id: current_user.library_id).count
            end
             render json: library, status: :ok
           end

          def index
            @library = Library.all
            render json:@library
          end

          def create
            # challenge = Challenge.new(title:"Lorem Ipsum 2", description:"Random Description2", start_date:Date.today, end_date:Date.tomorrow)
            library = Library.new(library_params)

            if library.save
              render json: {message: "Library Succesfully added!", data: library}
            else
              render json: {message: "Failed To Add Library", data: library.errors}, status: :unprocessable_entity
            end

          end

          def show
            library = Library.find(params[:id])
              if book
                render json: {message: "Data Found!", result: library}
              else
                render json: {message:"Data Not Found!", result: library.errors}
              end
          end

          def update
            library = Library.find(params[:library][:id])

            if library.update(library_params)
              render json: {message: "Data Updated Successfully", result: library}
            else
              render json: {message: "Data not updated", result: library.errors}
            end
          end

          def destroy
            p "------------------------------------------"
            puts params[:library][:id]
            library = Library.find(params[:library][:id])
            if library.destroy
              render json: {message:"Data Deleted Successfully!", result: library}
            else
              render json: {message:"Data not Deleted", result: library.errors}
            end

          end


          def search 
              query = params[:searchValue]
              # library = Library.where("name ILIKE? OR address ILIKE?", "%#{query}%", "%#{query}%")
              library = Library.where("name ILIKE? ", "%#{query}%")
              render json: library, status: :ok
          end

          private
          def library_params
              params.require(:library).permit(:name, :address, :phone_number, :email, :website)
          end

          # def authorize_admin
          #   unless current_user.email == "admin@example.com"
          #     render json: {message: "Unauthorized Access!"}
          #   end
          # end
    end
  end
end