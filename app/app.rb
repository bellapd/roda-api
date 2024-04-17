# frozen_string_literal: true

require 'roda'
require_relative 'controllers/locations_controllers'
# Main application class for the Navitogether API
module Navitogether
  class App < Roda
    plugin :json
    plugin :all_verbs

    route do |r|
      r.on 'locations' do
        r.run Navitogether::LocationsController
      end

      # Define a root route that returns a basic JSON message
      r.root do
        { message: 'Navitogether API is up and running!' }
      end
    end
  end
end
