require 'digest/sha2'

class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  default "Message-ID"=>"#{Time.now.to_i.to_s}"
  layout 'mailer'
end
