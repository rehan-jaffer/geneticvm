require './vm'
require 'pp'
require './rasm'

class GeneticProgram
  def self.random(len)
    len.times.map { |_|
      [rand(0..11), rand(0..15), rand(0..15), rand(0..15)]
    }
  end
  def self.breed(p1, p2)
#    p1.slice(0, p1.size/2) + p2.slice(p2.size/2, p2.size)
   c = true
   if p1.size > p2.size
     p2, p1 = p1, p2
   end
   p1.zip(p1.map.with_index { |_,i| p2[i] }).map.with_index { |c1, i|
        c = !c if i % 4 == 0
        (c == true) ? c1[0] : c1[1]
     }
#  p3 = p1.concat(p2)
#  p3.shuffle.take(p3.size/2)

  end
  def self.mutate(p1)
    c = 0
    p1.map do |g|
      if rand(0..200) == 2
        g[rand(0..3)] += (rand(1..4) - 2)
        g
      end
      g
    end
  end
end

first_gen = 100.times.map { |_| GeneticProgram.random(rand(20)) }
inputs = (1..5).to_a
outputs = inputs.map { |x| ((x**2)).to_f }
first_gen_eval = []

1000.times do |i|
  first_gen_eval = first_gen.map { 
 |g|

   [g, inputs.map.with_index { |i,n|
     vm = VM.new([i]); 
     vm.load(g);
     ret = vm.run[0];
     (outputs[n] - ret).abs
   }.inject(:+), RASM.disasm(g)]

  }.keep_if { |x| !x[1].nan? }.sort { |x,y| x[1] <=> y[1] }

  if first_gen_eval.map { |x| x[1] }.any? { |x| x == 0 }
    break
  end

  pp first_gen_eval.first(5).map { |x| x[1] }.inject(:+) / 5

  winners = first_gen_eval.first(15).map { |x| x[0] }

  children = []
  winners.map.with_index { |g, i|
    i.upto(14) do |j|
        children.push(GeneticProgram.breed(g, winners[j]))
    end
  }

  new_gen = (10.times.map { |_| GeneticProgram.random(rand(20)) })
  first_gen = (winners.concat(children).concat(new_gen)).map { |w| GeneticProgram.mutate(w) } 

end

pp first_gen_eval.sort { |x,y| x[1] <=> y[1] }.reverse
