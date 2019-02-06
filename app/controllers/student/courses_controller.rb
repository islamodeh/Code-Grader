class Student::CoursesController < Student::StudentsController
  def index
    @courses = current_student.courses
  end
  
  def search
    # add search filters
    @pending_courses = current_student.pending_courses
    @courses = Course.all.includes(:instructor) - (current_student.courses + @pending_courses)
  end
  
  def enroll
    enrollment = current_student.enrollments.where(course_id: params[:course_id]).first_or_create(status: "Pending")
    
    if params[:state] == "enroll"
      if enrollment.status == "Pending"
        flash[:info] = "Requested to join #{enrollment.course.name}"
      end
    elsif params[:state] == "unenroll"
      flash[:info] = "Requested cancelled to join #{enrollment.course.name}"
      enrollment.destroy
    end
    redirect_to student_course_search_path
  end
end