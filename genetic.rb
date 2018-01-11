require './vm'
require 'pp'

class GeneticProgram
  def self.random(len)
    len.times.map { |_|
      [rand(0..11), rand(0..15), rand(0..15), rand(0..15), 0]
    }
  end
  def self.breed(p1=[], p2=[])
    p1.slice(0, p1.size/2) + p2.slice(p2.size/2, p2.size)
  end
end

first_gen = 10.times.map { |_| GeneticProgram.random(rand(2..15)) }
inputs = (0..5).to_a
outputs = inputs.map { |x| (x**2)+35+Math.sin(2*x) }

10.times do |i|
  first_gen_eval = first_gen.map { 
 |g|

   [g, inputs.map.with_index { |i,n|
     vm = VM.new([i]); 
     vm.load(g); 
     Math.sqrt((outputs[n]-vm.run[0])**2)
   }.inject(:+)]
  }

  pp first_gen_eval
  
  sorted = first_gen_eval.sort { |x,y| x[1] <=> y[1] }

  winners = sorted.take(10).map { |x| x[0] }

  children = []
  winners.shuffle.each_cons(2) do |x,y|
    children.push(GeneticProgram.breed(x, y))
    children.push(GeneticProgram.breed(y, x))
  end

  first_gen = winners + children

end
