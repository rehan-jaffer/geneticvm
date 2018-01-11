require './vm'

describe VM do

  let(:vm) { VM.new() }

  describe "registers" do

    it "returns its registers as an array" do
      expect(vm.registers.class).to be Array
    end

    it "should be possible to load initial register values" do
      expect(VM.new([1]).registers[0]).to eql 1
    end

    it "should return the initial register values in R0 when run" do
      vm = VM.new([15])
      vm.load([ [0, 0, 0, 0] ])
      expect(vm.run[0]).to eql 15
    end

    it "should crash when given a garbage opcode" do
      vm = VM.new
      vm.load([ [667, 0, 0, 0] ])
#      expect { vm.run }.to raise UnimplementedOpcode
    end

    it "shouldn't run when given bad instruction code" do
      vm = VM.new
      vm.load([ [0, 0, 0] ])
      vm.run
#      expect { vm.run }.to raise Exception
    end

  end

    describe "instruction set" do
      it "RI = RJ + RK" do
        vm = VM.new([0, 8, 8])
        vm.load([ [1, 0, 1, 2, 0] ])
        expect(vm.run[0]).to eql 16
      end

      it "RI = RJ - RK" do
        vm = VM.new([0, 5, 3])
        vm.load([ [2, 0, 1, 2, 0] ])
        expect(vm.run[0]).to eql 2
      end

      it "RI = RJ * RK" do
        vm = VM.new([0, 2, 2])
        vm.load([ [3, 0, 1, 2, 0] ])
        expect(vm.run[0]).to eql 4
      end

      it "RI = RJ / RK" do
        vm = VM.new([
      end

      it "RI = RJ ^ RK" do

      end

      it "RI = exp(RJ)" do

      end
    end

   
end
