require './program'
require './vm'
require './rasm'
require './compiler'
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

  def set(flag, value)
    @settings[flag] = value
  end

  def fitness(f, input_range=[])
    @fitness = f
    @inputs = input_range
    @outputs = @inputs.map { |x| @fitness.call(x) }
  end

  def generation_debug(n, evaluated_generation)

      best_three = evaluated_generation.sort_by { |x| x[1] }.first(3).map { |x| x[1].to_i }

      avg_fitness = evaluated_generation.map { |x| x.last }.inject(:+) / evaluated_generation.size
      avg_size = evaluated_generation.map { |x| x[0].size }.inject(:+) / evaluated_generation.size
      avg = best_three.inject(:+)/3

      puts "Generation #{n}: #{avg}/#{@max} (avg size: #{avg_size}/#{evaluated_generation.size} #{best_three})"

  end

  def random_candidate(candidates)
    
  end

  def start(generations)

    generation_evaluation = []

    @max = @outputs.inject(:+)

    generations.times do |i|

      generation_evaluation = @generation.map { |c| e = Evaluation.new(c, @inputs, @outputs); [c, e.run]; } 

      generation_debug(i, generation_evaluation)

      top_ten_pair = generation_evaluation.sort_by { |x| x[1] }.keep_if { |z| z[1] < @max }

      survivors = generation_evaluation.sort_by { |x| x[1] }.keep_if { |z| z[1] < @max*2 }.map { |x| x[0] }.take(300)

      top_ten = top_ten_pair.map { |x| x[0] }
      top_ten_scores = top_ten_pair.map { |x| x[1] }

      if top_ten_scores.include?(0)
        pp top_ten.map { |p| RASM.disasm(p) }
        exit
      end

      children = []

      total = top_ten_scores.inject(:+)
      ratios = top_ten_scores.map { |score| ((1.0-(score.to_f/total.to_f))*300.0 || 300.0) }

      (top_ten_pair).each_with_index do |c, i|
       (10-i).times do |k|
          children.push(ProgramCandidate.breed(c[0], top_ten.shuffle.first))
        end
      end

      g_size = (top_ten.size + children.size + survivors.size)
      deficit = 1000-g_size

      @generation = (top_ten + children + survivors).map { |w| BasicMutator.mutate(w) }
      @generation.concat(deficit.times.map { |_| ProgramCandidate.random(rand(4..20)) })
    end

    pp generation_evaluation.sort_by { |x| x[1]}.take(5).map { |r| [r[1], RASM.disasm(r[0])] }

  end

end
