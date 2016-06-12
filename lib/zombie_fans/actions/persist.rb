require 'fileutils'
require 'json'
require 'yaml'

module ZombieFans::Actions
  module Persist
    ATTRIBUTES = %w(name login email password repos)

    def save
      record = {}
      ATTRIBUTES.each do |key|
        attribute = instance_variable_get(:"@#{key}")
        record[key] = attribute if attribute
      end

      yaml = Persist.load
      yaml << record
      Persist.dump yaml
    end

    class << self
      attr_accessor :path

      def path
        @path ||= File.expand_path '../../../../db/zombie_fans.yml', __FILE__
      end

      def load
        return [] unless File.exist? path
        YAML.load(File.read(path)) || []
      end

      def dump yaml
        FileUtils.mkdir_p(File.dirname(path))
        File.write(path, YAML.dump(yaml))
      end
    end

    module ClassMethods
      def init_attributes
        attr_accessor *ATTRIBUTES
      end

      def sample
        yaml = Persist.load
        new yaml.sample
      end
    end
  end
end
