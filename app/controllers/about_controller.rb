class AboutController < ApplicationController
    def index
        @user = current_user
        @statistics = @user.statistic if @user
    end
end
