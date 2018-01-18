require './simulator'
require './vm'

initial_population = ARGV[0].to_i
generations = ARGV[1].to_i

sim = Simulator.new(initial_population, -> { ProgramCandidate.random(rand(20)) })
sim.fitness(-> (x) { (x**3) }, (1..4).to_a)
sim.start(generations)

