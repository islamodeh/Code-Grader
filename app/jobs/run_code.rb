class RunCode < ActiveJob::Base
  include SuckerPunch::Job
  attr_accessor :submission

  def perform(submission)
    
  end
end
