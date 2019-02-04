module SessionHelper
  extend ActiveSupport::Concern
  
  def after_sign_in_path_for(user)
    case user.class.name
    when "Instructor"
      instructor_path
    when "Student"
      student_path
    else
      root_path
    end
  end
  
  # def after_sign_out_path_for(user)
  #   binding.pry
  # end
  
  def get_zone_name
    # use client ip to get zone name..
    "Asia/Muscat"
  end
  
  def current_user
    current_student || current_instructor
  end
  
end