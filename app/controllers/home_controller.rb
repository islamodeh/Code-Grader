class HomeController < ApplicationController
  def index
    if current_user.present?
      redirect_to after_sign_in_path_for(current_user)
      return
    end
  end

  def help
  end
end
