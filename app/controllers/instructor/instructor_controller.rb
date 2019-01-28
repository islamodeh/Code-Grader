class Instructor::InstructorController < ApplicationController
  before_action :authenticate_instructor!
  
  def index
    # render json: {test: "gg"}
  end

end
