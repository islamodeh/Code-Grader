class Instructor::WorksController < Instructor::InstructorsController
  def index
    @course = current_instructor.courses.find_by(id: params[:course_id])
  end

  def new
    @course = current_instructor.courses.find_by(id: params[:course_id])
    @work = @course.works.new
  end

  def create
    @course = current_instructor.courses.find_by(id: params[:course_id])
    @work = @course.works.new(work_params_require)

    if @work.save
      flash[:success] = "#{@work.work_type} created, Please add at least 1 test sample so the students can submit their code!"
      redirect_to(instructor_course_works_path(params[:course_id])) 
    else
      flash[:danger] = @work.errors.full_messages.join(", ")
      render :new
    end
  end

  def show
    @work = current_instructor.courses.find_by(id: params[:course_id]).works.find_by(id: params[:id])
  end

  def edit
    @course = current_instructor.courses.find_by(id: params[:course_id])
    @work = @course.works.find_by(id: params[:id])
  end

  def update
    @course = current_instructor.courses.find_by(id: params[:course_id])
    @work = @course.works.find_by(id: params[:id])


    if @work.update(work_params_require)
      flash[:success] = "#{@work.work_type} updated!"
      redirect_to(instructor_course_works_path(@course))
    else
      flash[:danger] = @work.errors.full_messages.join(", ")
      render :edit
    end
  end

  def destroy
    course = current_instructor.courses.find_by(id: params[:course_id])
    work = course.works.find_by(id: params[:id])

    if work.destroy
      flash[:success] = "#{work.work_type} deleted!"
    else
      flash[:danger] = work.errors.full_messages.join(", ")
    end

    redirect_to(instructor_course_works_path(course))
  end

  def student_submissions
    course = current_instructor.courses.find_by(id: params[:course_id])
    @work = course.works.find_by(id: params[:work_id])
    @student = Student.find_by(id: params[:id])
    @std_submissions = @work.submissions.where(userable: @student).where.not(status: "Cheated").order(created_at: :desc)
  end

  private

  def work_params_require
    params.require(:work).permit(:name, :work_type, :description, :start_date, :end_date)
  end
end
