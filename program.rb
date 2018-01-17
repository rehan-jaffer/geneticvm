INSTRUCTION_COUNT = 16
REGISTER_COUNT = 24
MUTATION_FREQ = 60

class Program

  def initialize(code)
    @mem = code
  end

  def translate()
    
  end

end

class Mutator

  def self.mutate(p1)
  end

end

class BasicMutator

  def self.mutate(p1)
    c = 0
    p1.each do |g|
      if rand(0..MUTATION_FREQ) == 2
        op = rand(0..3)
        if op == 0
          g[op] = ((rand(-3..3)) + g[op]).abs % (INSTRUCTION_COUNT-1)
        else
          g[op] = ((rand(-3..3).to_f) + g[op]).abs % (REGISTER_COUNT-1)
        end
      end
    end
    return p1
  end

end

class ProgramCandidate

  def self.random(len)
    len.times.map { |_|
      [rand(0..INSTRUCTION_COUNT-1), rand(0..REGISTER_COUNT-1), rand(0..REGISTER_COUNT-1), rand(0..REGISTER_COUNT-1)]
    }
  end

  def self.breed(p1, p2)
#    return p1.slice(0, p1.size/2).concat(p2.slice(p2.size/2, p2.size))
#   c = true
   p_size = [p1.size, p2.size].sort[0]
   c1 = rand(0..p_size)
   c2 = rand(0..p_size)
   segment = p2[c1, c2]
   p3 = p1[0, c1] + p2[c1, c2] + p1[c1, p1.size]
   p3
#  p3 = p1.concat(p2)
#  p3.shuffle.take(p3.size/2)

  end


end
