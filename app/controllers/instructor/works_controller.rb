class Instructor::WorksController < Instructor::InstructorsController
  
  def new
    @work = current_instructor.courses.find_by(id: params[:course_id]).works.new
  end

  def create
    work = current_instructor.courses.find_by(id: params[:course_id]).works.new(params_require)
    work.zone_name = get_zone_name
    work.save
    if work.valid?
      flash[:success] = "#{work.work_type} created !"
    else
      flash[:danger] = work.errors.full_messages.join(", ")
    end
    redirect_to new_instructor_course_work_path
  end
  
  private
  def params_require
    params.require(:work).permit!
  end
end
