# frozen_string_literal: true

require 'yaml'

# Model class representing a location in the Navitogether system
module Navitogether
  STORE_DIR = 'db/store'
  class Location
    attr_reader :id, :name, :checkins

    # Set up a class instance variable to hold the file path
    @db_file = File.expand_path('db/users.yml', __dir__)

    class << self
      attr_reader :db_file

      # All methods need to access the db_file through the accessor now
      def find(id)
        all.find { |location| location['id'] == id }
      end

      def all
        YAML.load_file(db_file) || []
      rescue Errno::ENOENT
        []
      end

      def next_id
        max_id = all.map { |location| location['id'].to_i }.max
        max_id ? (max_id + 1).to_s : '1'
      end

      def delete(id)
        locations = all.reject { |location| location['id'] == id }
        File.open(db_file, 'w') { |file| file.write(locations.to_yaml) }
      end

      def update(id, attributes)
        locations = all
        location = locations.find { |loc| loc['id'] == id }
        return unless location

        attributes.each do |key, value|
          location[key] = value if location.key?(key)
        end

        File.open(db_file, 'w') { |file| file.write(locations.to_yaml) }
      end
    end

    def initialize(name:, checkins:, id: nil)
      @id = id || self.class.next_id
      @name = name
      @checkins = checkins
    end

    def save
      locations = self.class.all
      @id ||= self.class.next_id
      locations << to_h
      File.open(self.class.db_file, 'w') { |file| file.write(locations.to_yaml) }
    end

    def to_h
      { 'id' => @id, 'name' => @name, 'checkins' => @checkins }
    end
  end
end
