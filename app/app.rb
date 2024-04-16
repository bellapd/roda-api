# frozen_string_literal: true

require 'roda'
require 'json'
require_relative 'controllers/locations_controllers'

# class for the app
class App < Roda
  plugin :json # This plugin allows us to return JSON responses
  plugin :all_verbs # This plugin allows us to use all HTTP verbs

  route do |r|
    r.on 'locations' do
      r.run LocationsController
    end
  end
end
