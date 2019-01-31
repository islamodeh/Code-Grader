class Instructor::CoursesController < Instructor::InstructorsController
  
  def index
    @courses = current_instructor.courses
  end

  def new
    @course = Course.new
  end

  def create
    if (course = current_instructor.courses.create(params_require)) && course.valid?
      flash[:success] = "Course created Succefully!"
    else
      flash[:danger] = course.errors.full_messages.join(", ")
    end
    redirect_to(new_instructor_course_path)
  end

  def show
    @course = current_instructor.courses.find_by(id: params[:id])
  end
  
  def edit
    @course = current_instructor.courses.find_by(id: params[:id])
  end
  
  def update
    @course = current_instructor.courses.find_by(id: params[:id])
    if @course.present? && @course.update(params_require)
      flash[:success] = "Updated!"
    else
      flash[:danger] = @course.errors.full_messages.join(", ")
    end
    redirect_to(edit_instructor_course_path(@course.id))
  end

  private
  def params_require
    params.require(:course).permit(:name, :section, :description)
  end
end