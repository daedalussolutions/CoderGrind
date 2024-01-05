class RegistrationsController < ApplicationController
    def new
        @user = User.new
    end

    def show
        redirect_to root_path
    end

    def create
        @user = User.new(registration_params)
        if @user.save
            login @user
            redirect_to root_path
        else
            render :new, status: :unprocessable_entity
        end
    end

    private

    def registration_params
        params.require(:user).permit(:email, :username, :password, :password_confirmation)
    end
end