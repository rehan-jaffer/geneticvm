require './simulator'
require './vm'

initial_population = ARGV[0].to_i
generations = ARGV[1].to_i

sim = Simulator.new(initial_population, -> { ProgramCandidate.random(20) })
sim.fitness(-> (x) { (2*(x**2)+(2*x)+8) }, (-4..4).to_a)
sim.start(generations)

