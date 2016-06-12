module ZombieFans::Actions
  module Query
    module ClassMethods
      def find query, key = 'login'
        yaml = Persist.load
        new yaml.find { |record| record[key] == query }
      end
    end
  end
end
