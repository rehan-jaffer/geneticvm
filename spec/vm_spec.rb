require './vm'
require './ops'

describe VM do

  let(:vm) { VM.new() }

  describe "registers" do

    it "should return the initial register values in R0 when run" do
      vm = VM.new([15])
      vm.load([ [NOOP, R0, R0, R0] ])
      expect(vm.run[0]).to eql 15.0
    end

    it "should return MAGIC_NUMBER if the values in R0 are unchanged with the MANGLE_UNCHANGED_INPUT flag" do
      vm = VM.new([15])
      vm.load([ [NOOP, R0, R0, R0] ])
      vm.set_flags([MANGLE_UNCHANGED_INPUT])
      expect(vm.run[0]).to eql 99.0    
    end

    it "should crash when given a garbage opcode" do
      vm = VM.new
      vm.load([ [667, R0, R0, R0] ])
#      expect { vm.run }.to raise UnimplementedOpcode
    end

    it "shouldn't run when given bad instruction code" do
      vm = VM.new
      vm.load([ [NOOP, R0, R0, R0] ])
      vm.run
#      expect { vm.run }.to raise Exception
    end

  end

    describe "instruction set" do

      context "basic operators" do

        it "NOOPs" do
          vm = VM.new([0, 0, 0])
          vm.load([ [NOOP, R0, R0, R0] ])
          expect(vm.run[0]).to eql 0.0
        end

        it "RI = RJ + RK" do
          vm = VM.new([0, 8, 8])
          vm.load([ [ADD, R0, R1, R2] ])
          expect(vm.run[0]).to eql 16.0
        end

        it "RI = RJ - RK" do
          vm = VM.new([0, 5, 3])
          vm.load([ [MINUS, R0, R1, R2] ])
          expect(vm.run[0]).to eql 2.0
        end

        it "RI = RJ * RK" do
          vm = VM.new([0, 2, 2])
          vm.load([ [MULTIPLY, R0, R1, R2] ])
          expect(vm.run[0]).to eql 4.0
        end

        it "RI = RJ / RK" do
          vm = VM.new([0, 4, 2])
          vm.load([ [DIVIDE, R0, R1, R2] ])
          expect(vm.run[0]).to eql 2.0
        end

      end

      context "exponential operators" do

        it "RI = RJ ^ RK" do
          vm = VM.new([0, 2, 3])
          vm.load([ [POW, R0, R1, R2] ])
          expect(vm.run[0]).to eql 8.0
        end

        it "RI = exp(RJ)" do
          vm = VM.new([0, 2])
          vm.load([ [EXP, R0, R1, R0] ])
          expect(vm.run[0]).to eql Math.exp(2)
        end

        it "RI = LN(RJ)" do
          vm = VM.new([0, 2])
          vm.load([ [LOG, R0, R1, R0] ])
          expect(vm.run[0]).to eql Math.log(2)
        end

        it "RI = RJ^2" do
          vm = VM.new([0, 2])
          vm.load([ [SQUARED, R0, R1, R0] ])
          expect(vm.run[0]).to eql 4.0
        end

        it "RI = sqrt(RJ)" do
          vm = VM.new([0, 4])
          vm.load([ [SQRT, R0, R1, R0] ])
          expect(vm.run[0]).to eql 2.0
        end

      end

      context "trigonometric operators" do

        it "RI = Math.sin(RJ)" do
          vm = VM.new([0, 1])
          vm.load([ [SIN, R0, R1, R0] ])
          expect(vm.run[0]).to eql Math.sin(1)
        end

        it "RI = Math.cos(RJ)" do
          vm = VM.new([0, 1])
          vm.load([ [COS, R0, R1, R0] ])
          expect(vm.run[0]).to eql Math.cos(1)
        end

      end

    end

    context "conditional operators" do

      it "IF (RJ > RK) THEN" do
          vm = VM.new([1, 2, 3])
          vm.load([ [IF_GT, R0, R2, R1], [ADD, R0, R1, R0], [NOOP, R0, R0, R0] ])
          expect(vm.run[0]).to eql 3.0
      end

      it "(RJ <= RK) THEN" do
          vm = VM.new([3, 2, 3])
          vm.load([ [IF_GT, R0, R1, R2], [ADD, R0, R1, R0], [NOOP, R0, R0, R0] ])
          expect(vm.run[0]).to eql 3.0
      end

    end
  
    context "nested conditional operators" do

      it "IF (RJ > RK) & (RJ > RK) THEN (positive path)" do
          vm = VM.new([1, 2, 3])
          vm.load([ [IF_GT, R0, R2, R1], [IF_GT, R0, R1, R0], [ADD, R0, R1, R0], [NOOP, R0, R0, R0] ])
          expect(vm.run[0]).to eql 3.0
      end

      it "IF (RJ > RK) & (RJ > RK) THEN (negative path)" do
          vm = VM.new([1, 2, 3])
          vm.load([ [IF_GT, R0, R2, R1], [IF_GT, R0, R2, R3], [ADD, R0, R1, R0], [NOOP, R0, R0, R0] ])
          expect(vm.run[0]).not_to eql 1.0
      end

      it "IF (RJ > RK) & (RJ > RK) THEN (negative path II)" do
          vm = VM.new([1, 2, 3])
          vm.load([ [IF_GT, R0, R1, R2], [IF_GT, R0, R3, R2], [
ADD, R0, R1, R0], [NOOP, R0, R0, R0] ])
          expect(vm.run[0]).to eql 1.0
      end

    end

    context "handling overflow/divide by zero" do
    
      it "returns high value on divide by zero" do
        vm = VM.new([0, 0])
        vm.load([ [DIVIDE, R0, R1, R0] ])
        expect(vm.run[0]).to be > MAGIC_NUMBER
      end


    end

    context "small test programs" do

      it "a + b * c" do
        vm = VM.new([1, 2, 3])
        vm.load([ [MULTIPLY, R3, R2, R1], [ADD, R0, R3, R0, R0] ])
        expect(vm.run[0]).to eql 7.0
      end

      it "test program 2" do
        vm = VM.new([1, 2, 3, 4])
        vm.load([[ADD, R0, R1, R2], [ IF_GT, R0, R1, R0 ], [ ADD, R4, R0, R1 ], [ NOOP, R0, R0, R0 ], [ADD, R0, R4, R1]])
        expect(vm.run[0]).to eq 2.0
      end

    end
   
end
