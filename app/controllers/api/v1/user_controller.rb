module Api
  module V1
  class UserController < ApplicationController

    # GET /getReaders
    # Fetches all users with the role 'reader'.
    # - Super Admin: Fetches readers across all libraries.
    # - Other Users: Fetches readers only in the current user's library.
    def getReaders
      if current_user.role == 'super_admin'
        @users = User.where(role: 'reader')
      else
        @users = User.where(role: 'reader', library_id: current_user.library_id)
      end
      render json: @users, status: :ok
    end

    # GET /users
    # Fetches all users excluding the currently logged-in user.
    # Includes associated library details (if available) and the role of each user.
    def index
      @users = User.left_joins(:library).where.not(id: current_user.id).select('users.*, libraries.name as library_name, users.role as role_value')
      render json: @users, status: :ok
    end

    # DELETE /users/:id
    # Deletes a specific user based on the provided ID.
    def destroy
      puts params[:user][:id]
      user = User.find(params[:user][:id])
      user.destroy
      render json: { message: 'User deleted successfully' }, status: :ok
    end

    # PUT /users/:id
    # Updates the details of a specific user based on the provided ID.
    def update
      user = User.find(params[:user][:id])
      if user.update(user_params)
        render json: {message: "user Updated Successfully", result: user}
      else
        render json: {message: "Data not updated", result: user.errors}, status: :unprocessable_entity
      end
    end

    # GET /users/search
    # Searches for users based on a provided query string.
    # - Matches users by their name (case-insensitive).
    # - Includes associated library details and the role of each user.
    def search
      query = params[:searchValue]
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