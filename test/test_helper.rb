require 'simplecov'
SimpleCov.start do
  add_filter 'test/' # Tests should not be counted toward coverage.
end

require 'date'

require "minitest"
require "minitest/autorun"
require "minitest/reporters"

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

# require_relative your lib files here!
require_relative '../lib/hoteldate'
require_relative '../lib/hotel_block'
require_relative '../lib/reservation'
require_relative '../lib/room'
require_relative '../lib/system'
