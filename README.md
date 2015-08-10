# Green Button Data

[![CI Results](https://img.shields.io/circleci/project/VerdigrisTech/green-button-data.svg)](https://circleci.com/gh/VerdigrisTech/green-button-data)
[![Gem Version](https://img.shields.io/gem/v/green-button-data.svg)](https://rubygems.org/gems/green-button-data)
[![Dependencies](https://img.shields.io/gemnasium/VerdigrisTech/green-button-data.svg)](https://gemnasium.com/VerdigrisTech/green-button-data)
[![Code Coverage](https://img.shields.io/codecov/c/github/VerdigrisTech/green-button-data.svg)](https://codecov.io/github/VerdigrisTech/green-button-data)
[![Code Climate](https://img.shields.io/codeclimate/github/VerdigrisTech/green-button-data.svg)](https://codeclimate.com/github/VerdigrisTech/green-button-data)

Green Button Data is a Ruby gem that can quickly parse the Green Button data
standard. It uses an event-driven <abbr title="Simple API for XML">SAX</abbr>
parser which does not build the entire <abbr title="Document Object Model">DOM</abbr>
in memory.

## Getting Started

Add the Green Button Data gem to your Gemfile:

```ruby
gem 'green-button-data'
```

Then run Bundler:

```bash
$ bundle
```

Green Button Data gem follows semantic versioning so if you wish to stay up to
date without backwards breaking changes, you can add a pessimistic version

## Configuration

You can add configuration options like the following:

```ruby
GreenButtonData.configure do |config|
  config.base_url = "https://services.greenbuttondata.org/"
  config.application_information_path = "DataCustodian/espi/1_1/resource/ApplicationInformation"
  config.authorization_path = "DataCustodian/espi/1_1/resource/Authorization"
  config.interval_block_path = "DataCustodian/espi/1_1/resource/IntervalBlock"
  config.meter_reading_path = "DataCustodian/espi/1_1/resource/MeterReading"
  config.usage_point_path = "DataCustodian/espi/1_1/resource/UsagePoint"
  config.usage_summary_path = "DataCustodian/espi/1_1/resource/UsageSummary"
end
```

### Rails

If you are developing a Rails app, create a file at
`config/initializers/green_button_data.rb` from your Rails project root and
add the configuration there.

## Fetching Data from an API Endpoint

Green Button Data specification states that all API endpoints be secured with
OAuth2 which means most of the fetch operation will require an auth token.

Some endpoints are secured further by utilizing client SSL certificates (e.g.
Pacific Gas & Electric). You may pass in `client_ssl` options in addition to
the `token` option in this case.

> **DISCLAIMER:** Green Button Data is **_NOT_** responsible for managing OAuth
tokens to make authenticated requests. There are other gems that provide mature,
production proven OAuth 2 functionalities such as OmniAuth.

### List all entries

By default, the `#all` method attempts to use the URL path set by configuration:

```ruby
require 'green-button-data'

# Ideally obtained from OmniAuth gem
access_token = "12345678-1024-2048-abcdef001234"

# Return all usage points; URL is specified in GreenButtonData.configuration.usage_point_url
usage_points = UsagePoint.all token: access_token
```

You may override the global configuration by specifying the URL in the method:

```ruby
usage_points = UsagePoint.all "https://someotherapi.org/espi/Authorization",
                              token: access_token
```

### Find an entry by ID

If you have URL defined in configuration, the `#find` method appends the ID to
the URL:

```ruby
GreenButtonData.configure do |config|
  config.base_url = "https://services.greenbuttondata.org/"
  config.usage_point_path = "DataCustodian/espi/1_1/resource/UsagePoint/"
end

# GET request to https://services.greenbuttondata.org/DataCustodian/espi/1_1/resource/UsagePoint/2
usage_point = GreenButtonData::UsagePoint.find 2, token: access_token
```

As with `#all` method, URL can be overridden per request in `#find`:

```ruby
usage_point = GreenButtonData::UsagePoint.find "https://someotherapi.org/espi/UsagePoint/1",
                                               token: access_token
```

## Parsing

Almost all of the functionality for parsing data is wrapped in the
`GreenButtonData::Feed` class.

To parse a Green Button Atom feed, simply call the `parse` method and pass in
the entire XML document:

```ruby
require 'green-button-data'

xml_text = File.read "#{File.dirname __FILE__}/gb_example_interval_block.xml"
data = GreenButtonData::Feed.parse xml_text
```

You can then access the data like this:

```ruby
# Print all the interval readings from the feed
data.entries.each do |entry|
  p "Entry: #{entry.title}"
  entry.content.interval_block.interval_readings.each do |reading|
    time_period = reading.time_period
    p "[#{time_period.starts_at} - #{time_period.ends_at}]: #{reading.value}"
  end
end
```

## Contributing

1. Fork this project
2. Create a feature branch: `git checkout -b my-awesome-feature`
3. Make changes and commit: `git commit -am "Add awesome feature"`
4. Push the branch: `git push origin my-awesome-feature`
5. Submit a pull request

## License

This software is distributed AS IS WITHOUT WARRANTY under [Simplified BSD](https://raw.githubusercontent.com/VerdigrisTech/green-button-data/master/LICENSE.txt)
license.

Verdigris Technologies Inc. assumes NO RESPONSIBILITY OR LIABILITY
UNDER ANY CIRCUMSTANCES for usage of this software. See the [LICENSE.txt](https://raw.githubusercontent.com/VerdigrisTech/green-button-data/master/LICENSE.txt)
file for detailed legal information.

Copyright © 2015, Verdigris Technologies Inc. All rights reserved.
