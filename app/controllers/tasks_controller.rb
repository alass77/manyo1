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
      tasks = tasks.search_status(params[:search][:status]) if params[:search][:status].present?
      tasks = tasks.search_title(params[:search][:title]) if params[:search][:title].present?
      tasks = tasks.search_label_id(params[:search][:label_id]) if params[:search][:label_id].present?
    end

    @tasks = tasks.page(params[:page]).per(10)
    @labels = current_user.labels.pluck(:name, :id)
  end

  # GET /tasks/1 or /tasks/1.json
  def show
    current_user_required(@task.user)
  end

  # GET /tasks/new
  def new
    @task = Task.new
    @labels = current_user.labels
  end

  # GET /tasks/1/edit
  def edit
    current_user_required(@task.user)
    @labels = current_user.labels
  end

  # POST /tasks or /tasks.json
  def create
    @task = Task.new(task_params)
    @task.user = current_user
    @task.labels << current_user.labels.where(id: params[:task][:label_ids])

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
    @task.labels.clear
    @task.labels << current_user.labels.where(id: params[:task][:label_ids])

    if @task.update(task_params)
      redirect_to tasks_path, notice: "La tâche a été supprimé avec succès" 
    else
      render :edit, status: :unprocessable_entity
    end
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
