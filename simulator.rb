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

  def start(generations)
    generations.times do |i|
      generation_evaluation = @generation.map { |c| e = Evaluation.new(c, @inputs, @outputs); [c, e.run]; } 
      avg_fitness = generation_evaluation.map { |x| x[1] }.inject(:+) / @generation.size
      puts "Generation #{i}: #{avg_fitness}"
      top_ten = generation_evaluation.sort_by { |x| x[1] }.take(10)
      children = []
      top_ten.map.with_index { |g, i|
        i.upto(9) do |j|
          children.push(ProgramCandidate.breed(g, top_ten[j][0]))
        end
      }
      @generation = (top_ten.map { |x| x[0] } + children).map { |w| ProgramCandidate.mutate(w) }
    end
    pp @generation.sort_by { |x| x[1]}.take(10).map { |r| RASM.disasm(r[0]) }
  end

end

sim = Simulator.new(100, -> { ProgramCandidate.random(10) })
sim.fitness(-> (x) { Math.sin(x) + x**2 }, (0..10).to_a)
sim.start(1000)
