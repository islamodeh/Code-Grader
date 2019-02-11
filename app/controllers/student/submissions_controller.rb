class Student::SubmissionsController < Student::StudentsController
  def new
    @course = current_student.courses.find_by(id: params[:course_id])
    @work = @course.works.find_by(id: params[:work_id])
    old_submission = @work.submissions.find_by(student_id: current_student.id)
    @submission = old_submission || @work.submissions.new(student_id: current_student.id, code: Submission::C_EX, language: "C")
  end
  
  def create
    @course = current_student.courses.find_by(id: params[:course_id])
    @work = @course.works.find_by(id: params[:work_id])
    @submission = @work.submissions.first_or_initialize(student_id: current_student.id)
    @submission.code = params[:submission]["code"]
    @submission.language = params[:submission]["language"]
    if @submission.save
      flash[:success] = "Code submitted successfuly."
    else
      flash[:danger] = @submission.errors.full_messages.join(", ")
    end
    redirect_to student_course_works_path(@course.id)
  end
end