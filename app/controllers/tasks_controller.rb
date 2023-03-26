class TasksController < ApplicationController
  def index
    @tasks = Task.order(:priority)
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
    @task.priority = Task.maximum(:priority).to_i + 1

    respond_to do |format|
      if @task.save
        format.html { redirect_to tasks_path, notice: "The task was successfully created." }
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
        #format.html { redirect_to task_url(@task), notice: "The task was successfully updated." }
        format.html { redirect_to tasks_path, notice: "The task was successfully updated." }
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
      format.html { redirect_to tasks_path, notice: "The task was successfully deleted." }
      format.json { head :no_content }
    end
  end

  #updates the priorities of all tasks when they are rearranged in the UI
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

  #tasks can be marked as completed or incomplete; this action will update a task accordingly
  def update_completed_status
    @task = Task.find(params[:id])
    is_complete = ActiveModel::Type::Boolean.new.cast(params[:is_checked])

    if is_complete
      @task.update(date_completed: Time.now.strftime("%Y-%m-%d %H:%M:%S"))
      status = "completed"
      notice = "The task was marked as completed"
    else
      @task.update(date_completed: nil)
      status = "incomplete"
      notice = "The task was marked as incomplete"
    end

    render json: { status: status, notice: notice }
    #redirect_to tasks_path
  end

  private
  def task_params
    params.require(:task).permit(:name, :description, :deadline, :date_completed, :priority)
  end

end
