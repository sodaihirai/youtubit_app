class ApplicationMailer < ActionMailer::Base
  default from: 'noreply@example.com',
                 'Content-Transfer-Encoding' => '7bit'
  layout 'mailer'
end
