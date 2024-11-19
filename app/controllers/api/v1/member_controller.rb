module Api
  module V1
    class MemberController < ApplicationController
        before_action  :unauthorized_access


          # GET /fetchMemberCount
          # Fetches the total count of members.
          # - For super_admin: counts all members.
          # - For other users: counts members belonging to the current user's library.
          def fetchMemberCount
             if current_user.role == 'super_admin'
                member = Member.all.count
             else
              member = Member.where(library_id: current_user.library_id).count
             end

             render json: member, status: :ok
          end

          # GET /members
          # Fetches a list of members.
          # - For super_admin: fetches all members with their associated library names.
          # - For other users: fetches members belonging to the current user's library.
          def index
            if current_user.role == 'super_admin'
              @member = Member.joins(:library).select('members.*, libraries.name as library_name')
            else 
            puts current_user.inspect
              @member  = Member.where(library_id: current_user.library_id).joins(:library).select('members.*, libraries.name as library_name') 
            end
            render json: @member
          end

          # POST /members
          # Creates a new member with the provided parameters.
          def create
            member = Member.new(member_params)
            if member.save
              render json: {message: "Data Succesfully added!", data: member}
            else
              render json: {message: "Failed To Add Book!", data: member.errors}
            end

          end


          # GET /members/:id
          # Fetches the details of a specific member by their ID.
          def show
            member = Member.find(params[:id])
              if member
                render json: {message: "Data Found!", result: member}
              else
                render json: {message:"Data Not Found!", result: member.errors}
              end
          end


          # PUT /members/:id
          # Updates the details of a specific member by their ID.
          def update
            member = Member.find(params[:member][:id])
            if member.update(member_params)
              render json: {message: "Data Updated Successfully", result: member}
            else
              render json: {message: "Data not updated", result: member.errors}
            end
          end

          # DELETE /members/:id
          # Deletes a specific member by their ID.
          def destroy
            member = Member.find(params[:member][:id])
            if member.destroy
              render json: {message:"Data Deleted Successfully!", result: member}
            else
              render json: {message:"Data not Deleted", result: member.errors}
            end

          end

          # GET /members/search
          # Searches members by their name (case-insensitive).
          # Supports partial matches for the name.
          def search
            query = params[:searchValue]
            # library = Library.where("name ILIKE? OR address ILIKE?", "%#{query}%", "%#{query}%")
            member = Member.where("name ILIKE? ", "%#{query}%")
            render json: member, status: :ok
          end

          private
          def member_params
              params.require(:member).permit(:name, :membership_start_date, :number_of_books_issued, :email, :phone_number, :address, :library_id)
          end


          def unauthorized_access
            render json: { error: 'Access denied' }, status: :forbidden unless current_user&.role!='reader'
          end
    end
  end
end