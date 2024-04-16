# frozen_string_literal: true

# config.ru

require_relative 'app/app'

run App.freeze.app
