INSTRUCTION_COUNT = 16
REGISTER_COUNT = 16

class ProgramCandidate
  def self.random(len)
    len.times.map { |_|
      [rand(0..INSTRUCTION_COUNT-1), rand(0..REGISTER_COUNT-1), rand(0..REGISTER_COUNT-1), rand(0..REGISTER_COUNT-1)]
    }
  end
  def self.breed(p1, p2)
    return p1.slice(0, p1.size/2).concat(p2.slice(p2.size/2, p2.size))
#   c = true
#   if p1.size > p2.size
#     p2, p1 = p1, p2
#   end
#   p1.zip(p1.map.with_index { |_,i| p2[i] }).map.with_index { |c1, i|
#        c = !c if i % 4 == 0
#        (c == true) ? c1[0] : c1[1]
#     }
#  p3 = p1.concat(p2)
#  p3.shuffle.take(p3.size/2)

  end
  def self.mutate(p1)
    c = 0
    p1.map do |g|
      if rand(0..90) == 2
        op = rand(0..3)
        g[op] = ((rand(1..4) - 2) + g[op]).abs % 15
        g
      end
      g
    end
  end
end
