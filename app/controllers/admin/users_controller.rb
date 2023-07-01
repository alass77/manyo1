class Admin::UsersController < ApplicationController
    before_action :set_user, only: %i(show edit update destroy)
    before_action :admin_required

    def new
        @user=User.new
        
    end

    def index
        @users = User.includes(:tasks).all
    end

    def create
        @user = User.new(user_params)
        if @user.save
        redirect_to admin_users_path , notice: "J'ai réussi à créer un compte"
        else
        render :new
        end
    end

    def show
        @user = User.find(params[:id])
    end

    def edit
        @user = User.find(params[:id])
    end

    def update
        @user = User.find(params[:id])
        if @user.update(user_params)
            redirect_to admin_users_path, notice: "J'ai mis à jour mon compte"
        else
            render :edit
        end
    end

    def destroy
        @user = User.find(params[:id])
        @user.destroy
        redirect_to admin_users_path, notice: "L'utilisateur a été supprimé avec succès."
    end
      


    private

    def set_user
        @user = User.find(params[:id])
    end

    def user_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
    end
end
