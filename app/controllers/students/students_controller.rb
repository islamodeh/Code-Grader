class Students::StudentsController < ApplicationController
  before_action :authenticate_student!
  
  def index
    render json: {user: "Student"}
  end
end