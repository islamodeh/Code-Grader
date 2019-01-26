module ApplicationHelper
  def current_user
    if instructor_signed_in?
      current_instructer
    elsif student_signed_in?
      current_student
    end
  end

  def logout_path
    case current_user.class.name
    when "Instructor"
      destroy_instructor_session_path
    when "Student"
      destroy_student_session_path
    end
  end

end
