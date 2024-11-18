module Api
  module V1
  class UserController < ApplicationController
    # before_action  :unauthorized_access


    def getReaders
      # users = User.all
      if current_user.role == 'super_admin'
        @users = User.where(role: 'reader')
      else
        @users = User.where(role: 'reader', library_id: current_user.library_id)
      end
    
      render json: @users, status: :ok
    end

    def index
      # users = User.all
      @users = User.left_joins(:library).where.not(id: current_user.id).select('users.*, libraries.name as library_name, users.role as role_value')
      render json: @users, status: :ok
    end

    def destroy
      puts params[:user][:id]
      user = User.find(params[:user][:id])
      user.destroy
      render json: { message: 'User deleted successfully' }, status: :ok
    end

    def update
      p "*************************************"
      puts params[:user][:id]
       p "*******************---------------------***************"
      user = User.find(params[:user][:id])

      if user.update(user_params)
        render json: {message: "user Updated Successfully", result: user}
      else
        render json: {message: "Data not updated", result: user.errors}, status: :unprocessable_entity
      end
    end


    def search
      query = params[:searchValue]
      # library = Library.where("name ILIKE? OR address ILIKE?", "%#{query}%", "%#{query}%")
      user = User.where("users.name ILIKE? ", "%#{query}%").left_joins(:library).select('users.*, libraries.name as library_name, users.role as role_value')
      render json: user, status: :ok
    end

    private
    def user_params
        params.require(:user).permit(:name, :email, :role, :library_id, :password)
    end

    def unauthorized_access
      render json: { error: 'Unauthorized access' }, status: :unauthorized unless current_user.present?
    end
  end

  end
end