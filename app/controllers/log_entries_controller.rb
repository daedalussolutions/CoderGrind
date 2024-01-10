class LogEntriesController < ApplicationController
    before_action :authenticate_user!

    def index
        @user = current_user
        @statistics = @user.statistic if @user

        @log_entries = current_user.log_entries.order(created_at: :desc).paginate(page: params[:page], per_page: 10)
    end

    def create
        @log_entry = current_user.log_entries.build(log_entry_params)
        @log_entry.date = Date.current

        if @log_entry.save
            current_user.update_statistics
            redirect_to "/dashboard", notice: 'Logged session.'
        else
            puts @log_entry.errors.full_messages
            redirect_to "/dashboard", notice: 'Session not logged'
        end
    end

    def edit
        @user = current_user
        @statistics = @user.statistic if @user
        @log_entry = current_user.log_entries.find_by(params[:id])
    end

    def update
        @user = current_user
        @statistics = @user.statistic if @user
        @log_entry = current_user.log_entries.find_by(params[:id])
    
        if @log_entry.update(log_entry_params)
            current_user.update_statistics
            redirect_to "/dashboard"
        else
            render :edit
        end
        
      end

    def destroy
        @log_entry = current_user.log_entries.find_by(params[:id])
        @log_entry.destroy
        current_user.update_statistics
        redirect_to "/dashboard", notice: 'Log entry deleted.'
    end

    private

    def log_entry_params
        params.require(:log_entry).permit(:title, :project, :time, :lines, :characters, :language, :framework, :contributions)
    end
end
