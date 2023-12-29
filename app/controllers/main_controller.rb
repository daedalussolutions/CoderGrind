class MainController < ApplicationController
    def index
        @user = current_user
        @statistics = @user.statistic if @user
    end
    def entries
        # Display all created entries.

    end
end