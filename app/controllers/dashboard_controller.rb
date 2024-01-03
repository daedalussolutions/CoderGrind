class DashboardController < ApplicationController
    before_action :authenticate_user!
    def index
        if user_signed_in?
            @user = current_user
            @statistics = @user.statistic if @user
        else
            redirect_to root_path
        end
    end
end
