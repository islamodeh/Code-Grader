class Student::SubmissionsController < Student::StudentsController
  def index
    @course = current_student.courses.find_by(id: params[:course_id])
    @work = @course.works.find_by(id: params[:work_id])
    @submissions = @work.submissions.where(userable: current_student).order(created_at: :desc)
  end

  def new
    @course = current_student.courses.find_by(id: params[:course_id])
    @work = @course.works.find_by(id: params[:work_id])
    last_submission = @work.submissions.where(userable: current_student).order(created_at: :desc).first
    code = last_submission.present? ? last_submission.code : Submission::C_EX
    language = last_submission.present? ? last_submission.language : "C"
    @submission = @work.submissions.new(userable: current_student, code: code, language: language)
  end

  # def show
  #   @course = current_student.courses.find_by(id: params[:course_id])
  #   @work = @course.works.find_by(id: params[:work_id])
  #   @submission = @work.submissions.where(id: params[:id], userable: current_student).first
  # end

  def create
    @course = current_student.courses.find_by(id: params[:course_id])
    @work = @course.works.find_by(id: params[:work_id])
    @submission = @work.submissions.new(userable: current_student,
                                        status: "Pending".to_sym,
                                        code: params[:submission][:code],
                                        language: params[:submission][:language],
                                        grade: 0)
    if @submission.save
      RunCode.perform_async(@submission)
      flash[:success] = "Code submitted successfuly. Please wait few seconds for the result"
    else
      flash[:danger] = @submission.errors.full_messages.join(", ")
    end
    redirect_to(student_course_work_submissions_path(@course.id, @work.id))
  end
end
