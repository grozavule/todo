class TasksController < ApplicationController
  def index
    @tasks = Task.all
  end

  def show
  end

  def new
    @task = Task.new
  end

  def edit
    @task = Task.find(params[:id])
  end

  def create
    @task = Task.new(task_params)

    respond_to do |format|
      if @task.save
        format.html { redirect_to task_url(@task), notice: "The task was successfully created." }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      @task = Task.find(params[:id])
      if @task.update(task_params)
        format.html { redirect_to task_url(@task), notice: "The task was successfully updated." }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    respond_to do |format|
      format.html { redirect_to task_url, notice: "The task was successfully deleted." }
      format.json { head :no_content }
    end
  end

  #updates the priorities of all tasks when they are shuffled in the UI
  def set_priority
    priority_level = 1;
    index_priorities = {};

    index_order = params[:new_index_order]
    index_order.each do |index|
      @task = Task.find(index);
      @task.priority = priority_level;
      @task.save
      index_priorities[index] = priority_level
      priority_level += 1
    end
    render json: { priority_levels: index_priorities }
  end

  private
  def task_params
    params.require(:task).permit(:name, :description, :deadline, :date_completed, :priority)
  end

end
