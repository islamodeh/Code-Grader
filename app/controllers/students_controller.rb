class StudentsController < ApplicationController
  before_action :authenticate_student!
  def index
  end
  def destroy
    raise 'here'
  end
end
