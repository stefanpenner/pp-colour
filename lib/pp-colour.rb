require 'prettyprint'
path = File.dirname(__FILE__)
%W{string
   kernel
   temp
   array
   hash
   struct
   file
   range
   matchdata
   other}.each { |file| require File.join(path,'pp-colour',file)}
