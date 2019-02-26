require 'digest/sha2'

class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  default "Message-ID"=>"#{Digest::SHA2.hexdigest(Time.now.to_i.to_s)}@gmail.com"
  layout 'mailer'
end
