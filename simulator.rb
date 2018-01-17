require './program'
require './vm'
require './rasm'
require 'pp'

class Evaluation

  def initialize(program, inputs, outputs)
    @inputs, @outputs = inputs, outputs
    @program = program
  end

  def run
    @inputs.map.with_index { 
      |input, index|
      vm = VM.new([input])
      vm.load(@program)
      r = vm.run
      ret = r[0]
      (@outputs[index] - ret).abs
    }.inject(:+)
  end

end

class Simulator

  def initialize(initial_population_size, candidate_generator, flags=[])
    @generation = initial_population_size.times.map { |_| candidate_generator.call }
  end

  def fitness(f, input_range=[])
    @fitness = f
    @inputs = input_range
    @outputs = @inputs.map { |x| @fitness.call(x) }
  end

  def generation_debug(n, evaluated_generation)

      best_three = evaluated_generation.sort_by { |x| x[1] }.first(3).map { |x| x[1].to_i }

      if best_three.include?(0)
        pp evaluated_generation.sort_by { |x| x[1] }.first(4).map { |r| RASM.disasm(r[0]) }
        exit
      end

      avg_fitness = evaluated_generation.map { |x| x.last }.inject(:+) / evaluated_generation.size
      avg_size = evaluated_generation.map { |x| x[0].size }.inject(:+) / evaluated_generation.size

      puts "Generation #{n}: #{avg_fitness} (avg size: #{avg_size}/#{evaluated_generation.size} #{best_three})"

  end

  def start(generations)

    generations.times do |i|

      generation_evaluation = @generation.map { |c| e = Evaluation.new(c, @inputs, @outputs); [c, e.run]; } 

      generation_debug(i, generation_evaluation)

      top_ten = generation_evaluation.sort_by { |x| x[1] }.take(10).map { |x| x[0] }

      children = []

      top_ten.map.with_index { |g, i|
        (i+i).upto(3) do |j|
            20.times do 
              children.push(ProgramCandidate.breed(g, top_ten[j]))
            end
        end
      }

      @generation = (top_ten + children).map { |w| BasicMutator.mutate(w) }

    end

    pp @generation.sort_by { |x| x[1]}.take(5).map { |r| [RASM.disasm(r)] }

  end

end

sim = Simulator.new(400, -> { ProgramCandidate.random(rand(2..30)) })
sim.fitness(-> (x) { (((x**2)+x)+20) }, (1..10).to_a)
sim.start(1000)
