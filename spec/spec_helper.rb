require 'rack/test'
require 'rspec'

require File.expand_path '../../app.rb', __FILE__

ENV['RACK_ENV'] = 'test'

module RSpecMixin
  include Rack::Test::Methods
  
  def app
  	Sinatra::Application 
  end

	def session
	  last_request.env['rack.session']
	end
end

# For RSpec 2.x
RSpec.configure { |c| c.include RSpecMixin }

