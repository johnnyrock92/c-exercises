require 'c-exercises'

gem 'rack-codehighlighter'
require 'rack/codehighlighter'

gem 'ultraviolet'
require 'uv'

use Rack::ShowExceptions
use Rack::Lint
#use Rack::Codehighlighter, :ultraviolet, :theme => "dawn", :element => "pre>code"
use Rack::Codehighlighter, :ultraviolet, :markdown => true, :element => "pre>code", :pattern => /\A:::([-\w]+)\s*\n/

run WB::CExercises.new
