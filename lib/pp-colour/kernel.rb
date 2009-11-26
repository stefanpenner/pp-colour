module Kernel
  # returns a pretty printed object as a string.
  def pretty_inspect
    PP.pp(self, '')
  end
 
  private
  # prints arguments in pretty form.
  #
  # pp returns nil.
  def pp(*objs) # :doc:
    objs.each {|obj|
      PP.pp(obj)
    }
    nil
  end
  module_function :pp
end

