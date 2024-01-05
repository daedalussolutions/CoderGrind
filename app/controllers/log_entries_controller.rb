class LogEntriesController < ApplicationController
    before_action :authenticate_user!

    def create
        @log_entry = current_user.log_entries.build(log_entry_params)

        if @log_entry.save
            current_user.update_statistics
            redirect_to "/dashboard", notice: 'Logged session.'
        else
            puts @log_entry.errors.full_messages
            redirect_to "/dashboard", notice: 'Session not logged'
        end
    end

    def edit
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
