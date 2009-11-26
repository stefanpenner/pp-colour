class Struct
  def pretty_print(q)
    q.group(1, '#<struct ' + PP.mcall(self, Kernel, :class).name, '>') {
      q.seplist(PP.mcall(self, Struct, :members), lambda { q.text "," }) {|member|
        q.breakable
        q.text member.to_s
        q.text '='
        q.group(1) {
          q.breakable ''
          q.pp self[member]
        }
      }
    }
  end
 
  def pretty_print_cycle(q)
    q.text sprintf("#<struct %s:...>", PP.mcall(self, Kernel, :class).name)
  end
end

