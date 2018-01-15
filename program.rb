INSTRUCTION_COUNT = 16
REGISTER_COUNT = 4

class ProgramCandidate
  def self.random(len)
    len.times.map { |_|
      [rand(0..INSTRUCTION_COUNT-1), rand(0..REGISTER_COUNT-1), rand(0..REGISTER_COUNT-1), rand(0..REGISTER_COUNT-1)]
    }
  end
  def self.breed(p1, p2)
#    return p1.slice(0, p1.size/2).concat(p2.slice(p2.size/2, p2.size))
#   c = true
   if p2.size > p1.size
     p2, p1 = p1, p2
   end
   c = true
   s = rand(1..8)
   p1.zip(p2).map.with_index { |c1, i|
        c = !c if i % s == 0
        (c == true) ? c1[0] : c1[1]
     }.compact
#  p3 = p1.concat(p2)
#  p3.shuffle.take(p3.size/2)

  end
  def self.mutate(p1)
    c = 0
    p1.each do |g|
      if rand(0..80) == 2
        op = rand(0..3)
        if op == 0
          g[op] = ((rand(1..2) - 1) + g[op]).abs % (INSTRUCTION_COUNT-1)
        else
          g[op] = ((rand(1..2) - 1) + g[op]).abs % (REGISTER_COUNT-1)
        end
        if g == nil
          exit
        end
      end
    end
    return p1
  end
end
