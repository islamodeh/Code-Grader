class Instructor::CoursesController < Instructor::InstructorsController
  
  def index
    # render json: {test: "123"}
  end

  def show
    
  end
  
  def new
    @course = Course.new
  end

  def create
    if (course = current_user.courses.create(params_require)) && course.valid?
      flash[:success] = "Course created Succefully!"
    else
      flash[:danger] = course.errors.full_messages.join(", ")
    end
    redirect_to(new_instructor_course_path)
  end

  private
  def params_require
    params.require(:course).permit(:name, :section, :description)
  end
end