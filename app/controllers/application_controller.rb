class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    include SessionsHelper

    before_action :login_required
  
    private
        def login_required
        redirect_to new_session_path, alert: "Veuillez vous connecter" unless current_user
        end

        def already_logged_in
        redirect_to tasks_path, alert: "veuillez vous déconnecter" if current_user
        end

        def admin_required
        redirect_to tasks_path, alert: "Seuls les administrateurs peuvent accéder" unless current_user.admin
        end
        
        def current_user_required(user)
        redirect_to tasks_path, alert: "Vous seul pouvez accéder" unless current_user ==  user
        end
end
