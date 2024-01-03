class MainController < ApplicationController
    def index
        if @user
            redirect_to '/dashboard'
        end
    end
end