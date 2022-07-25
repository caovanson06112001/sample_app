class ApplicationMailer < ActionMailer::Base
  default from: "host_email"
  layout "mailer"
end
