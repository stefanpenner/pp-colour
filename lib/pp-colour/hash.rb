class Hash
  def pretty_print(q)
    q.pp_hash self
  end
 
  def pretty_print_cycle(q)
    q.text(empty? ? '{}'.green : '{...}'.green)
  end
end

