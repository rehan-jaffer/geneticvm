INSTRUCTION_COUNT = 12

class ProgramCandidate

  def self.random(len)
    len.times.map { |_|
      [rand(0..11), rand(0..15), rand(0..15), rand(0..15), 0]
    }
  end
  def self.breed(p1=[], p2=[])
    p1.slice(0, p1.size/2) + p2.slice(p2.size/2, p2.size)
  end
end
