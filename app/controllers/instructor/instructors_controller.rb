class Instructor::InstructorsController < ApplicationController
  before_action :authenticate_instructor!

  def index
  end
end
