# frozen_string_literal: true

# app/controllers/locations_controller.rb
require 'roda'

# Controller for Location-related routes and actions
class LocationsController < Roda
  plugin :json
  plugin :all_verbs

  # Simulating a database with an in-memory array
  LOCATIONS = [{ 'id' => '1', 'name' => 'John',
                 'checkins' => [{ 'lat' => '6.5542937', 'lng' => '3.3665464999999997' }] }].freeze

  route do |r|
    # POST /locations - Create a new location
    r.post do
      new_id = (LOCATIONS.map { |location| location['id'].to_i }.max || 0) + 1
      new_location = {
        'id' => new_id.to_s,
        'name' => r.params['name'],
        'checkins' => r.params['checkins'] ? JSON.parse(r.params['checkins']) : []
      }
      LOCATIONS.push(new_location)
      new_location
    end

    # GET /locations/:id - Retrieve a specific location by ID
    r.get String do |id|
      location = LOCATIONS.find { |loc| loc['id'] == id }
      location || response.status = 404
    end

    # PUT /locations/:id - Update a specific location by ID
    r.put String do |id|
      location = LOCATIONS.find { |loc| loc['id'] == id }
      if location
        location['name'] = r.params['name'] if r.params['name']
        location['checkins'] = JSON.parse(r.params['checkins']) if r.params['checkins']
        location
      else
        response.status = 404
      end
    end

    # DELETE /locations/:id - Delete a specific location by ID
    r.delete String do |id|
      location = LOCATIONS.find { |loc| loc['id'] == id }
      if location
        LOCATIONS.delete(location)
        response.status = 204
      else
        response.status = 404
      end
    end
  end
end
