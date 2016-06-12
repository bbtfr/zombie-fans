require 'open-uri'
# Don't allow downloaded files to be created as StringIO. Force a tempfile to be created.
OpenURI::Buffer.send :remove_const, 'StringMax' if OpenURI::Buffer.const_defined?('StringMax')
OpenURI::Buffer.const_set 'StringMax', 0

require 'mechanize'

glob = File.expand_path("../actions/*.rb", __FILE__)
Dir[glob].each do |file|
  require file
end

module ZombieFans
  class Robot
    include Actions::Logger
    include Actions::Auth
    include Actions::Avatar
    include Actions::Repo
    include Actions::User

    include Actions::Persist
    extend Actions::Persist::ClassMethods
    init_attributes

    extend Actions::Query::ClassMethods

    attr_reader :agent

    AGENT_ALIASES = [
      'Linux Firefox', 'Linux Konqueror', 'Linux Mozilla', 'Mac Firefox', 'Mac Mozilla', 'Mac Safari 4', 'Mac Safari', 'Windows Chrome', 'Windows IE 6', 'Windows IE 7', 'Windows IE 8', 'Windows IE 9', 'Windows IE 10', 'Windows IE 11', 'Windows Edge', 'Windows Mozilla', 'Windows Firefox'
    ]

    def initialize attributes = {}
      # assign attributes
      attributes.each do |key, value|
        instance_variable_set(:"@#{key}", value)
      end

      @agent = Mechanize.new do |agent|
        agent.user_agent_alias = AGENT_ALIASES.sample
        agent.agent.allowed_error_codes = [500]
      end
    end
  end
end
