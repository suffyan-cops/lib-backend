module Api
  module V1
    class MemberController < ApplicationController
        before_action  :unauthorized_access
        # before_action :authorize_admin , only: %i[create update destroy]
           # before_action :set_challenge, only%i[show,update,destroy]

           def fetchMemberCount
             if current_user.role == 'super_admin'
                member = Member.all.count
             else
              member = Member.where(library_id: current_user.library_id).count
             end

             render json: member, status: :ok
           end
          def index
            # @member = Member.all
            if current_user.role == 'super_admin'
              @member = Member.joins(:library).select('members.*, libraries.name as library_name')
            else 
            puts current_user.inspect
              @member  = Member.where(library_id: current_user.library_id).joins(:library).select('members.*, libraries.name as library_name') 
           end
            render json: @member
          end

          def create
            # challenge = Challenge.new(title:"Lorem Ipsum 2", description:"Random Description2", start_date:Date.today, end_date:Date.tomorrow)
            member = Member.new(member_params)

            if member.save
              render json: {message: "Data Succesfully added!", data: member}
            else
              render json: {message: "Failed To Add Book!", data: member.errors}
            end

          end

          def show
            member = Member.find(params[:id])
              if member
                render json: {message: "Data Found!", result: member}
              else
                render json: {message:"Data Not Found!", result: member.errors}
              end
          end

          def update
            p "*************************************"
            member = Member.find(params[:member][:id])

            if member.update(member_params)
              render json: {message: "Data Updated Successfully", result: member}
            else
              render json: {message: "Data not updated", result: member.errors}
            end
          end

          def destroy
            member = Member.find(params[:member][:id])
            if member.destroy
              render json: {message:"Data Deleted Successfully!", result: member}
            else
              render json: {message:"Data not Deleted", result: member.errors}
            end

          end


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

          # def authorize_admin
          #   unless current_user.email == "admin@example.com"
          #     render json: {message: "Unauthorized Access!"}
          #   end
          # end
    end
  end
end