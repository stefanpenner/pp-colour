class MatchData
  def pretty_print(q)
    q.object_group(self) {
      q.breakable
      q.seplist(1..self.size, lambda { q.breakable }) {|i|
        q.pp self[i-1]
      }
    }
  end
end

