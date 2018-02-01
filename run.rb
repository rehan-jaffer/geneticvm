require './simulator'
require './vm'

initial_population = ARGV[0].to_i
generations = ARGV[1].to_i

sim = Simulator.new(initial_population, -> { ProgramCandidate.random(rand(10..100)) })
sim.fitness(-> (x) { (x**2)+4 }, (-6..6).to_a)
sim.start(generations)

