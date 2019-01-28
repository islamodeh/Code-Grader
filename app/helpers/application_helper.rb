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
      instructor_path
    when "Student"
      student_path
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

  def current_user_navbar_functions
    case current_user.class.name
    when "Instructor"
    ("<li class='nav-item active'>" + 
      (link_to "My Courses", instructor_courses_path, class: "nav-link") +
     "</li>").html_safe
    when "Student"
    ("<li class='nav-item active'>" + 
      (link_to "My Courses", student_courses_path, class: "nav-link") +
     "</li>").html_safe
    end
  end
end
