require 'sax-machine'
require 'faraday'

require 'green-button-data/configuration'
require 'green-button-data/core_extensions'
require 'green-button-data/utilities'
require 'green-button-data/dst'
require 'green-button-data/enumerations'
require 'green-button-data/parser'
require 'green-button-data/feed'
require 'green-button-data/relations'
require 'green-button-data/model_collection'
require 'green-button-data/fetchable'
require 'green-button-data/entry'
require 'green-button-data/application_information'
require 'green-button-data/authorization'
require 'green-button-data/interval_block'
require 'green-button-data/local_time_parameters'
require 'green-button-data/meter_reading'
require 'green-button-data/reading_type'
require 'green-button-data/usage_point'
require 'green-button-data/usage_summary'
require 'green-button-data/retail_customer'
require 'green-button-data/client'

module GreenButtonData
  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield configuration
  end

  def self.connect(configuration = {})
    client = Client.new configuration
    yield client
    return client
  end
end
