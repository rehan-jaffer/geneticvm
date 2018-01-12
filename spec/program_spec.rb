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

    it "breeds two functions and creates a valid program (instructions)" do
      expect(@p3.map { |i| i[0] }).to all be < INSTRUCTION_COUNT
    end

    it "breeds two functions and creates a valid program (r0)" do
      expect(@p3.map { |i| i[1] }).to all be < REGISTER_COUNT
    end

    it "breeds two functions and creates a valid program (r1)" do
      expect(@p3.map { |i| i[2] }).to all be < REGISTER_COUNT
    end

    it "breeds two functions and creates a valid program (r2)" do
      expect(@p3.map { |i| i[3] }).to all be < REGISTER_COUNT
    end

  end

end
