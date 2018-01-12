require './vm'
require 'pp'
require './rasm'

class GeneticProgram
  def self.random(len)
    len.times.map { |_|
      [rand(0..11), rand(0..2), rand(0..2), rand(0..2)]
    }
  end
  def self.breed(p1=[], p2=[])
    (p1 + p2).shuffle.take(p1.size)
#    p1.slice(0, p1.size/2) + p2.slice(p2.size/2, p2.size)
  end
  def self.mutate(p1)
    c = 0
    p1.map do |g|
      if rand(0..100) == 2
        g[rand(0..3)] += (rand(1..2) - 1)
        g
      end
      g
    end
  end
end

first_gen = 100.times.map { |_| GeneticProgram.random(rand(10)) }
inputs = (1..3).to_a
outputs = inputs.map { |x| ((x**4)).to_f }

1000.times do |i|
  first_gen_eval = first_gen.map { 
 |g|

   [g, inputs.map.with_index { |i,n|
     vm = VM.new([i]); 
     vm.load(g);
     ret = vm.run[0] 
     (outputs[n] - ret).abs
   }.inject(:+), RASM.disasm(g)]

  }.keep_if { |x| !x[1].nan? }

  pp first_gen_eval.map { |x| x[1] }
  sorted = first_gen_eval.sort_by { |x| x[1] }

  winners = sorted.take(10).map { |x| x[0] }

  children = []
  winners.shuffle.each_cons(2) do |x,y|
    children.push(GeneticProgram.breed(x, y))
    children.push(GeneticProgram.breed(y, x))
  end

  new_gen = (20.times.map { |_| GeneticProgram.random(rand(10)) })
  first_gen = (winners.concat(children).concat(new_gen)).map { |w| GeneticProgram.mutate(w) } 

end

pp first_gen.map { |x| RASM.disasm(x) }
