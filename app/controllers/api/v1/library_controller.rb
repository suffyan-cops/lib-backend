module Api
  module V1
    class LibraryController < ApplicationController
        before_action  :unauthorized_access

          # GET /fetchLibCount
          # Fetches the total count of libraries in the system.
          def fetchLibCount
              library = Library.all.count

             render json: library, status: :ok
          end

          # GET /fetchLibraryCount
          # Fetches the count of librarians based on the user's role.
          # - For super_admin: fetches all librarians.
          # - For other users: fetches librarians associated with the current user's library.
          def fetchLibraryCount
            if current_user.role =='super_admin'
              library = User.where(role: 'librarian').all.count
            else
              library = User.where(role: 'librarian').where.not(id: current_user.id).where(library_id: current_user.library_id).count
            end
             render json: library, status: :ok
          end

          # GET /libraries
          # Fetches a list of all libraries.
          def index
            @library = Library.all
            render json:@library
          end


          # POST /libraries
          # Creates a new library with the provided parameters.
          def create
            # challenge = Challenge.new(title:"Lorem Ipsum 2", description:"Random Description2", start_date:Date.today, end_date:Date.tomorrow)
            library = Library.new(library_params)
            if library.save
              render json: {message: "Library Succesfully added!", data: library}
            else
              render json: {message: "Failed To Add Library", data: library.errors}, status: :unprocessable_entity
            end
          end

          # GET /libraries/:id
          # Fetches the details of a specific library by its ID.
          def show
            library = Library.find(params[:id])
              if book
                render json: {message: "Data Found!", result: library}
              else
                render json: {message:"Data Not Found!", result: library.errors}
              end
          end

          # PUT /libraries/:id
          # Updates the details of a specific library by its ID.
          def update
            library = Library.find(params[:library][:id])
            if library.update(library_params)
              render json: {message: "Data Updated Successfully", result: library}
            else
              render json: {message: "Data not updated", result: library.errors}
            end
          end

          # DELETE /libraries/:id
          # Deletes a specific library by its ID.
          def destroy
            library = Library.find(params[:library][:id])
            if library.destroy
              render json: {message:"Data Deleted Successfully!", result: library}
            else
              render json: {message:"Data not Deleted", result: library.errors}
            end
          end

          # GET /libraries/search
          # Searches libraries by their name (case-insensitive).
          # Supports partial matches for the name.
          def search
              query = params[:searchValue]
              library = Library.where("name ILIKE? ", "%#{query}%")
              render json: library, status: :ok
          end


          def unauthorized_access
            render json: { error: 'Access denied' }, status: :unauthorized unless current_user.present?
          end

          private
          def library_params
              params.require(:library).permit(:name, :address, :phone_number, :email, :website)
          end
    end
  end
end