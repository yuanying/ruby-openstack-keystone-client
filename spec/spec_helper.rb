# coding: utf-8
require 'webmock/rspec'

require 'simplecov'
require 'simplecov-rcov'
class SimpleCov::Formatter::MergedFormatter
  def format(result)
     SimpleCov::Formatter::HTMLFormatter.new.format(result)
     SimpleCov::Formatter::RcovFormatter.new.format(result)
  end
end
SimpleCov.formatter = SimpleCov::Formatter::MergedFormatter
SimpleCov.start do
  add_filter '/spec/'
end

RSpec.configure do |config|
  config.mock_with :rspec
end

require 'examples/resource'
require 'examples/client'