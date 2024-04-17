# frozen_string_literal: true

require 'yaml'

module Navitogether
  class Location
    def init(new_checkins)
      @id = new_checkins['id']
      @name = new_checkins['name']
      @checkins = new_checkins['checkins']
    end

    # attr_reader is for defining a read- only instance variables
    attr_reader :id, :name, :checkins

    def to_json(options = {})
      JSON.generate(to_h, options)
    end

    def to_h
      { id: @id, name: @name, checkins: @checkins }
    end

    def self.setup
      Dir.mkdir(store_dir) unless Dir.exist?(store_dir)
      return if File.exist?("#{store_dir}/locations.yml")

      File.open("#{store_dir}/locations.yml", 'w') do |f|
        f.write("---\n")
      end
    end

    def self.all
      YAML.load_file("#{store_dir}/locations.yml")
    rescue Errno::ENOENT
      []
    end

    def self.find(id)
      all.find { |location| location['id'] == id }
    end

    def self.next_id
      max_id = all.map { |location| location['id'].to_i }.max
      max_id ? (max_id + 1).to_s : '1'
    end

    def self.delete(id)
      locations = all.reject { |location| location['id'] == id }
      File.open("#{store_dir}/locations.yml", 'w') { |file| file.write(locations.to_yaml) }
    end

    def self.update(id, attributes)
      locations = all
      location = locations.find { |loc| loc['id'] == id }
      return unless location

      attributes.each do |key, value|
        location[key] = value if location.key?(key)
      end

      File.open("#{store_dir}/locations.yml", 'w') { |file| file.write(locations.to_yaml) }
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
      File.open("#{store_dir}/locations.yml", 'w') { |file| file.write(locations.to_yaml) }
    end
  end
end
