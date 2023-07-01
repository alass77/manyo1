class TasksController < ApplicationController
  before_action :set_task, only: %i[ show edit update destroy ]

  # GET /tasks or /tasks.json
  def index
    if params[:sort_deadline_on]
      tasks = current_user.tasks.sort_deadline_on.sort_created_at
    elsif params[:sort_priority]
      tasks = current_user.tasks.sort_priority.sort_created_at
    else
      tasks = current_user.tasks.sort_created_at
    end
    
    if params[:search].present?
      if params[:search][:status].present? && params[:search][:title].present?
        tasks = tasks.search_status(params[:search][:status]).search_title(params[:search][:title])
      elsif params[:search][:status].present?
        tasks = tasks.search_status(params[:search][:status])
      elsif params[:search][:title].present?
        tasks = tasks.search_title(params[:search][:title])
      end
    end

    @tasks = tasks.page(params[:page]).per(10)
  end

  # GET /tasks/1 or /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks or /tasks.json
  def create
    @task = Task.new(task_params)
    @task.user = current_user

    if @task.save
      redirect_to tasks_path, notice: "La tâche a été créée avec succès"
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tasks/1 or /tasks/1.json
  def update
    if @task.update(task_params)
      redirect_to tasks_path, notice: "La tâche a été mis à jour avec succès" 
    else
      render :edit
    end
  end

  # DELETE /tasks/1 or /tasks/1.json
  def destroy
    @task.destroy
    redirect_to tasks_url, notice: "La tâche a été supprimé avec succès"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def task_params
      params.require(:task).permit(:title, :content, :created_at, :deadline_on, :priority, :status)
    end
end
