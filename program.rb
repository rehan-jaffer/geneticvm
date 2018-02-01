INSTRUCTION_COUNT = 15
REGISTER_COUNT = 32
MUTATION_FREQ = 50

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
          g[op] = ((rand(-1..1)) + g[op]).abs % (INSTRUCTION_COUNT-1)
        else
          g[op] = ((rand(-1..1).to_f) + g[op]).abs % (REGISTER_COUNT-1)
        end
      end
      exit if g.any? { |x| x.nil? }
    end
    return p1
  end

end

class BreedingFunction
  def breed(p1, p2)
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

   p_size = [p1.size, p2.size].sort.first

   begin
     p1_t = rand(0..p2.size/2)
     p2_t = rand(p1_t..p2.size)
     c2 = p2.slice(p1_t, (p2.size-p1_t))
   rescue
     puts p1_t
     puts p2_t
     exit
   end

   p1_c1 = rand(0..p1.size/2)
   p1_c2 = rand(p1_c1..p1.size)

   p3 = p1[0, p1_c1] + c2 + p1[p1_c2, (p1.size-p1_c2)]

   p3
#  p3 = p1.concat(p2)
#  p3.shuffle.take(p3.size/2)

  end


end
