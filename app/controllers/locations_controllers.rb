# frozen_string_literal: true

# app/controllers/locations_controller.rb
require 'roda'
require_relative '../models/location'

module Navitogether
  class LocationsController < Roda
    plugin :json
    plugin :all_verbs

    route do |r|
      r.on 'locations' do
        # POST /locations - Create a new location
        r.post do
          location = Location.new(name: r.params['name'], checkins: JSON.parse(r.params['checkins'] || '[]'))
          location.save
          location.to_h
        end

        # GET /locations/:id - Retrieve a specific location by ID
        r.get String do |id|
          location = Location.find(id)
          if location
            location # This will automatically convert to JSON
          else
            response.status = 404
            { error: 'Location not found' }.to_json # Explicit JSON response
          end
        end

        # PUT /locations/:id - Update a specific location by ID
        r.put String do |id|
          location = Location.find(id)
          if location
            updated_attributes = {
              'name' => r.params['name'],
              'checkins' => JSON.parse(r.params['checkins'] || '[]')
            }
            Location.update(id, updated_attributes)
            Location.find(id)
          else
            response.status = 404
            { error: 'Location not found' }
          end
        end

        # DELETE /locations/:id - Delete a specific location by ID
        r.delete String do |id|
          if Location.delete(id)
            response.status = 204
          else
            response.status = 404
            { error: 'Location not found' }
          end
        end
      end
    end
  end
end
