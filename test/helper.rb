$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..','lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rubygems'
require 'test/unit'
require 'shoulda'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'pp-colour'
require 'setup'

class Test::Unit::TestCase
end

