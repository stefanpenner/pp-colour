 
# == Pretty-printer for Ruby objects.
# 
# = Which seems better?
# 
# non-pretty-printed output by #p is:
#   #<PP:0x81fedf0 @genspace=#<Proc:0x81feda0>, @group_queue=#<PrettyPrint::GroupQueue:0x81fed3c @queue=[[#<PrettyPrint::Group:0x81fed78 @breakables=[], @depth=0, @break=false>], []]>, @buffer=[], @newline="\n", @group_stack=[#<PrettyPrint::Group:0x81fed78 @breakables=[], @depth=0, @break=false>], @buffer_width=0, @indent=0, @maxwidth=79, @output_width=2, @output=#<IO:0x8114ee4>>
# 
# pretty-printed output by #pp is:
#   #<PP:0x81fedf0
#    @buffer=[],
#    @buffer_width=0,
#    @genspace=#<Proc:0x81feda0>,
#    @group_queue=
#     #<PrettyPrint::GroupQueue:0x81fed3c
#      @queue=
#       [[#<PrettyPrint::Group:0x81fed78 @break=false, @breakables=[], @depth=0>],
#        []]>,
#    @group_stack=
#     [#<PrettyPrint::Group:0x81fed78 @break=false, @breakables=[], @depth=0>],
#    @indent=0,
#    @maxwidth=79,
#    @newline="\n",
#    @output=#<IO:0x8114ee4>,
#    @output_width=2>
# 
# I like the latter.  If you do too, this library is for you.
# 
# = Usage
# 
#   pp(obj)
#
# output +obj+ to +$>+ in pretty printed format.
# 
# It returns +nil+.
# 
# = Output Customization
# To define your customized pretty printing function for your classes,
# redefine a method #pretty_print(+pp+) in the class.
# It takes an argument +pp+ which is an instance of the class PP.
# The method should use PP#text, PP#breakable, PP#nest, PP#group and
# PP#pp to print the object.
#
# = Author
# Tanaka Akira <akr@m17n.org>
require 'prettyprint'
 
class PP < PrettyPrint
  # Outputs +obj+ to +out+ in pretty printed format of
  # +width+ columns in width.
  # 
  # If +out+ is omitted, +$>+ is assumed.
  # If +width+ is omitted, 79 is assumed.
  # 
  # PP.pp returns +out+.
  def PP.pp(obj, out=$>, width=79)
    q = PP.new(out, width)
    q.guard_inspect_key {q.pp obj}
    q.flush
    #$pp = q
    out << "\n"
    out
  end
 
  # Outputs +obj+ to +out+ like PP.pp but with no indent and
  # newline.
  # 
  # PP.singleline_pp returns +out+.
  def PP.singleline_pp(obj, out=$>)
    q = SingleLine.new(out)
    q.guard_inspect_key {q.pp obj}
    q.flush
    out
  end
 
  # :stopdoc:
  def PP.mcall(obj, mod, meth, *args, &block)
    mod.instance_method(meth).bind(obj).call(*args, &block)
  end
  # :startdoc:
 
  @sharing_detection = false
  class << self
    # Returns the sharing detection flag as a boolean value.
    # It is false by default.
    attr_accessor :sharing_detection
  end
 
  module PPMethods
    InspectKey = :__inspect_key__ unless defined? InspectKey
 
    def guard_inspect_key
      if Thread.current[InspectKey] == nil
        Thread.current[InspectKey] = []
      end
 
      save = Thread.current[InspectKey]
 
      begin
        Thread.current[InspectKey] = []
        yield
      ensure
        Thread.current[InspectKey] = save
      end
    end
 
    # Adds +obj+ to the pretty printing buffer
    # using Object#pretty_print or Object#pretty_print_cycle.
    # 
    # Object#pretty_print_cycle is used when +obj+ is already
    # printed, a.k.a the object reference chain has a cycle.
    def pp(obj)
      id = obj.__id__
 
      if Thread.current[InspectKey].include? id
        group {obj.pretty_print_cycle self}
        return
      end
 
      begin
        Thread.current[InspectKey] << id
        group {obj.pretty_print self}
      ensure
        Thread.current[InspectKey].pop unless PP.sharing_detection
      end
    end
 
    # A convenience method which is same as follows:
    # 
    #   group(1, '#<' + obj.class.name, '>') { ... }
    def object_group(obj, &block) # :yield:
      group(1, '#<'.green + obj.class.name.magenta, '>'.green, &block)
    end
 
    def object_address_group(obj, &block)
      id = "%x" % (obj.__id__ * 2)
      id.sub!(/\Af(?=[[:xdigit:]]{2}+\z)/, '') if id.sub!(/\A\.\./, '')
      group(1, "\#<#{obj.class.to_s.magenta}:".green + "0x#{id}".blue, '>'.green, &block)
    end
 
    # A convenience method which is same as follows:
    # 
    #   text ','
    #   breakable
    def comma_breakable
      text ','.blue
      breakable
    end
 
    # Adds a separated list.
    # The list is separated by comma with breakable space, by default.
    # 
    # #seplist iterates the +list+ using +iter_method+.
    # It yields each object to the block given for #seplist.
    # The procedure +separator_proc+ is called between each yields.
    # 
    # If the iteration is zero times, +separator_proc+ is not called at all.
    # 
    # If +separator_proc+ is nil or not given,
    # +lambda { comma_breakable }+ is used.
    # If +iter_method+ is not given, :each is used.
    # 
    # For example, following 3 code fragments has similar effect.
    # 
    #   q.seplist([1,2,3]) {|v| xxx v }
    # 
    #   q.seplist([1,2,3], lambda { comma_breakable }, :each) {|v| xxx v }
    # 
    #   xxx 1
    #   q.comma_breakable
    #   xxx 2
    #   q.comma_breakable
    #   xxx 3
    def seplist(list, sep=nil, iter_method=:each) # :yield: element
      sep ||= lambda { comma_breakable }
      first = true
      list.__send__(iter_method) {|*v|
        if first
          first = false
        else
          sep.call
        end
        yield(*v)
      }
    end
 
    def pp_object(obj)
      object_address_group(obj) {
        seplist(obj.pretty_print_instance_variables, lambda { text ','.green }) {|v|
          breakable
          v = v.to_s if Symbol === v
          text v
          text '='
          group(1) {
            breakable ''
            pp(obj.instance_eval(v))
          }
        }
      }
    end
 
    def pp_hash(obj)
      group(1, '{'.green, '}'.green) {
        seplist(obj, nil, :each_pair) {|k, v|
          group {
            pp k
            text '=>'.blue
            group(1) {
              breakable ''
              pp v
            }
          }
        }
      }
    end
  end
 
  include PPMethods
 
  class SingleLine < PrettyPrint::SingleLine
    include PPMethods
  end
 
  module ObjectMixin
    # 1. specific pretty_print
    # 2. specific inspect
    # 3. specific to_s if instance variable is empty
    # 4. generic pretty_print
 
    # A default pretty printing method for general objects.
    # It calls #pretty_print_instance_variables to list instance variables.
    # 
    # If +self+ has a customized (redefined) #inspect method,
    # the result of self.inspect is used but it obviously has no
    # line break hints.
    # 
    # This module provides predefined #pretty_print methods for some of
    # the most commonly used built-in classes for convenience.
    def pretty_print(q)
      if /\(Kernel\)#/ !~ Object.instance_method(:method).bind(self).call(:inspect).inspect
        q.text self.inspect.yellow.bold
      elsif /\(Kernel\)#/ !~ Object.instance_method(:method).bind(self).call(:to_s).inspect && instance_variables.empty?
        q.text self.to_s
      else
        q.pp_object(self)
      end
    end
 
    # A default pretty printing method for general objects that are
    # detected as part of a cycle.
    def pretty_print_cycle(q)
      q.object_address_group(self) {
        q.breakable
        q.text '...'.green
      }
    end
 
    # Returns a sorted array of instance variable names.
    # 
    # This method should return an array of names of instance variables as symbols or strings as:
    # +[:@a, :@b]+.
    def pretty_print_instance_variables
      instance_variables.sort
    end
 
    # Is #inspect implementation using #pretty_print.
    # If you implement #pretty_print, it can be used as follows.
    # 
    #   alias inspect pretty_print_inspect
    #
    # However, doing this requires that every class that #inspect is called on
    # implement #pretty_print, or a RuntimeError will be raised.
    def pretty_print_inspect
      if /\(PP::ObjectMixin\)#/ =~ Object.instance_method(:method).bind(self).call(:pretty_print).inspect
        raise "pretty_print is not overridden for #{self.class}"
      end
      PP.singleline_pp(self, '')
    end
  end
end
 
class << ENV
  def pretty_print(q)
    q.pp_hash self
  end
end
 
# :enddoc:
if __FILE__ == $0
  require 'test/unit'
 
end


