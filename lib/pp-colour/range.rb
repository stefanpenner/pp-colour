class Range
  def pretty_print(q)
    q.pp self.begin
    q.breakable ''
    q.text(self.exclude_end? ? '...'.green : '..'.green)
    q.breakable ''
    q.pp self.end
  end
end

