class Student::WorksController < Student::StudentsController
  def index
    @course = current_student.courses.find_by(id: params[:course_id])
    @course.works.each do |work|
      work.student_id = current_student.id
    end
  end
end