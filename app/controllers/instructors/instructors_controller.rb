class Instructors::InstructorsController < ApplicationController
  before_action :authenticate_instructor!
  
  def index
    render json: {user: "Instructor"}
  end
end
