Dir['models/*.rb'].each   { |file| require_relative file }
Dir['services/*.rb'].each { |file| require_relative file }
Dir['lib/*.rb'].each      { |file| require_relative file }

# libraries needed to generate / read CSV files
require 'csv'
require 'open-uri'

# For testing purposes
require 'pry'
require 'rb-readline'
