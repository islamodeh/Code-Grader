class Student::WorksController < Student::StudentsController
  def index
    @course = current_student.courses.find_by(id: params[:course_id])
  end
end