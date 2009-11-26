class HasInspect
  def initialize(a)
    @a = a
  end
 
  def inspect
    return "<inspect:#{@a.inspect}>"
  end
end
 
class HasPrettyPrint
  def initialize(a)
    @a = a
  end
 
  def pretty_print(q)
    q.text "<pretty_print:"
    q.pp @a
    q.text ">"
  end
end
 
class HasBoth
  def initialize(a)
    @a = a
  end
 
  def inspect
    return "<inspect:#{@a.inspect}>"
  end
 
  def pretty_print(q)
    q.text "<pretty_print:"
    q.pp @a
    q.text ">"
  end
end
 
class PrettyPrintInspect < HasPrettyPrint
  alias inspect pretty_print_inspect
end
 
class PrettyPrintInspectWithoutPrettyPrint
  alias inspect pretty_print_inspect
end

