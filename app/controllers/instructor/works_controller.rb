class Instructor::WorksController < Instructor::InstructorsController
  def index
    @course = current_instructor.courses.find_by(id: params[:course_id])
  end

  def new
    @course = current_instructor.courses.find_by(id: params[:course_id])
    @work = @course.works.new
  end

  def create
    work = current_instructor.courses.find_by(id: params[:course_id]).works.new(params_require)
    work.zone_name = get_zone_name
    if work.save
      flash[:success] = "#{work.work_type} created !
       Please add at least 1 test sample so the students can submit their code!"
    else
      flash[:danger] = work.errors.full_messages.join(", ")
      redirect_to(instructor_course_works_path(params[:course_id]))
      return
    end

    redirect_to(instructor_course_work_samples_path(params[:course_id], work.id))
  end

  def show
    @work = current_instructor.courses.find_by(id: params[:course_id]).works.find_by(id: params[:id])
  end

  def edit
    @course = current_instructor.courses.find_by(id: params[:course_id])
    @work = @course.works.find_by(id: params[:id])
  end

  def update
    course = current_instructor.courses.find_by(id: params[:course_id])
    work = course.works.find_by(id: params[:id])
    work.zone_name = get_zone_name

    if work.update(params_require)
      flash[:success] = "#{work.work_type} Updated!"
    else
      flash[:danger] = work.errors.full_messages.join(", ")
    end
    redirect_to(instructor_course_works_path(course))
  end

  def destroy
    course = current_instructor.courses.find_by(id: params[:course_id])
    work = course.works.find_by(id: params[:id])
    work.destroy
    flash["success"] = "#{work.work_type} deleted!"
    redirect_to(instructor_course_works_path(course))
  end

  def student_submissions
    course = current_instructor.courses.find_by(id: params[:course_id])
    @work = course.works.find_by(id: params[:work_id])
    @student = Student.find_by(id: params[:id])

    @std_submissions = @work.submissions.where(userable: @student).where.not(status: "Cheated").order(created_at: :desc)
  end

  private

  def params_require
    params.require(:work).permit(:name, :work_type, :description, :start_date, :end_date)
  end
end
