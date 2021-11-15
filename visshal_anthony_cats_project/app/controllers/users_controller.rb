class UsersController < ApplicationController

    before_action :has_no_user!

    def new
        @user = User.new
        render :new
    end

    def create
        @user = User.new(user_params)
        if @user.save
            login_user!(@user)
            redirect_to cats_url
        else
            render :new
        end
    end

    private
    def user_params
        params.require(:user).permit(:password, :user_name)
    end
end