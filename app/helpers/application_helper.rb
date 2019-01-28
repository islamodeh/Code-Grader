module ApplicationHelper
  def current_user
    if instructor_signed_in?
      current_instructor
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

  def profile_path
    case current_user.class.name
    when "Instructor"
      instructors_path
    when "Student"
      students_path
    end
  end

  def edit_path
    case current_user.class.name
    when "Instructor"
      edit_instructor_registration_path
    when "Student"
      edit_student_registration_path
    end
  end
end
