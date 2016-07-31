require 'eventmachine'
require 'ostruct'
require 'mail'

class SMTP < EventMachine::Protocols::SmtpServer
  def receive_sender(sender)
    current.sender = sender
    true
  end

  def receive_recipient(recipient)
    current.recipient = recipient
    true
  end

  def receive_message
    current.received = true
    current.completed_at = Time.now

    puts "==> SMTP: Received message from '#{current.sender}' (#{current.data.length} bytes)"

    if current.sender =~ /noreply@github.com/
      mail = Mail.new current.data
      plain_text = mail.body.parts.first.body.decoded
      if plain_text  =~ /https:\/\/github.com\/users\/(.*?)\/emails.*?(?=\n)/
        confirm_link = $&
        login = $1

        robot = ZombieFans::Robot.find login
        robot.sign_in
        robot.follow_confirm_link confirm_link
      end
    end

    true
  rescue => error
    puts "*** Error receiving message: #{current.inspect}"
    puts "    Exception: #{error}"
    puts "    Backtrace:"
    $!.backtrace.each do |line|
      puts "       #{line}"
    end
    false
  ensure
    @current = nil
  end

  def receive_data_command
    current.data = ""
    true
  end

  def receive_data_chunk(data)
    current.data << data.join("\n")
    true
  end

  def current
    @current ||= OpenStruct.new
  end

  def self.start(host = '0.0.0.0', port = 25)
    @server = EventMachine.start_server host, port, self
    puts "Starting MailCatcher on smtp://#{host}:#{port}"
  end

  def self.stop
    if @server
      EventMachine.stop_server @server
      @server = nil
    end
  end

  def self.running?
    !!@server
  end
 end
