[Numeric, Symbol, FalseClass, TrueClass, NilClass, Module].each do |c|
  c.class_eval do
    def pretty_print_cycle(q)
      q.text inspect.cyan
    end
  end
end
 
[Numeric].each do |c|
  c.class_eval do
    def pretty_print(q)
      q.text inspect.cyan
    end
  end
end

[FalseClass, TrueClass, Module].each do |c|
  c.class_eval do
    def pretty_print(q)
      q.text inspect.green.bold
    end
  end
end
