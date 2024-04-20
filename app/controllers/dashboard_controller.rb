class DashboardController < ApplicationController
    before_action :authenticate_user!
    def index
        if user_signed_in?
            @user = current_user
            @statistics = @user.statistic if @user
            @log_entries = current_user.log_entries.order(created_at: :desc).paginate(page: params[:page], per_page: 3)
            current_user.update_statistics
        else
            redirect_to root_path
        end
    end
end
