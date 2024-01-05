class SessionsController < ApplicationController
    def show
        redirect_to root_path
    end

    def create
        if user = User.authenticate_by(email: params[:email], password: params[:password])
            login user
            redirect_to '/dashboard', notice: "You have signed in."
        else
            flash[:alert] = "Invalid email or password."
            redirect_to root_path
        end
    end

    def destroy
        logout current_user
        redirect_to root_path, notice: "Logged out."
    end
end