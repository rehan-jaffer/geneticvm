require './program'
require './spec/support/program'

describe ProgramCandidate do

  context "breeding" do

    before(:all) do
      p1 = valid_program(10)
      p2 = valid_program(10)
      @p3 = ProgramCandidate.breed(p1,p2)
    end

    it "breeds two functions with the same size and produces a valid array" do
      expect(@p3.class).to eq Array
    end

    it "breeds two functions and creates a valid program" do
      expect(@p3.map { |i| i[0] }).to all be < INSTRUCTION_COUNT
    end

  end

end
