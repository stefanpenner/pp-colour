class Array
  def pretty_print(q)
    q.group(1, '['.green, ']'.green) {
      q.seplist(self) {|v|
        q.pp v
      }
    }
  end
 
  def pretty_print_cycle(q)
    q.text(empty? ? '[]'.green : '[...]'.green)
  end
end

