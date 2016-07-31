require 'zombie_fans'
require 'zombie_fans/smtp'

EventMachine.run { SMTP.start }
