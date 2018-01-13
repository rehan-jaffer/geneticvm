require 'pp'

DEBUG_MODE = false
MAGIC_NUMBER = 99.0
REG_SIZE = 4

class UnimplementedOpcode < StandardError
end

class VM

  def initialize(registers=[])
    initialize_registers(registers)
    @pc = 0
  end

  def initialize_registers(registers)
    @r = registers.map(&:to_f) + Array.new(REG_SIZE-registers.size, 0) + (0..9).to_a
#    Array.new(REG_SIZE-registers.size, -> { initial_register_value })
  end

  def initial_register_value
    0.0
  end

  def ops(n)
    ops = []
    ops[0] = -> (op, r1, r2, r3) { 1 }
    ops[1] = -> (op, r1, r2, r3) { @r[r1] = @r[r2] + @r[r3]; }
    ops[2] = -> (op, r1, r2, r3) { @r[r1] = @r[r2] - @r[r3]; }
    ops[3] = -> (op, r1, r2, r3) { @r[r1] = @r[r2] * @r[r3]; }
    ops[4] = -> (op, r1, r2, r3) { @r[r1] = @r[r2] / @r[r3]; }
    ops[5] = -> (op, r1, r2, r3) { @r[r1] = @r[r2] ** @r[r3]; }
    ops[6] = -> (op, r1, r2, r3) { @r[r1] = Math.exp(@r[r2]) }
    ops[7] = -> (op, r1, r2, r3) { @r[r1] = Math.log(@r[r2]); }
    ops[8] = -> (op, r1, r2, r3) { @r[r1] = @r[r2]**2 }
    ops[9] = -> (op, r1, r2, r3) { @r[r1] = Math.sqrt(@r[r2]); } 
    ops[10] = -> (op, r1, r2, r3) { @r[r1] = Math.sin(@r[r2]) }
    ops[11] = -> (op, r1, r2, r3) { @r[r1] = Math.cos(@r[r2]) }
    ops[n]
  end

  def debug(op_code, r1, r2, r3)

    return if DEBUG_MODE == false

    case op_code
      when 0
        puts "#{@pc} NOOP"
      when 1
        puts "#{@pc} r#{r1} = r#{r2} + r#{r3}"
      when 2
        puts "#{@pc} r#{r1} = r#{r2} - r#{r3}"
      when 4
        puts "#{@pc} r#{r1} = r#{r2} * r#{r3}"
      when 5
        puts "#{@pc} r#{r1} = r#{r2} / r#{r3}"
      when 6
        puts "#{@pc} r#{r1} = r#{r2} ** r#{r3}"
      when 7
        puts "#{@pc} r#{r1} = EXP(r#{r2})"
      when 8
        puts "#{@pc} r#{r1} = LOG(r#{r2})"
      when 9
        puts "#{@pc} r#{r1} = r#{r2} ** 2"
      when 10
        puts "#{@pc} r#{r1} = SIN(r#{r2})"
      when 11
        puts "#{@pc} r#{r1} = COS(r#{r2})"
      end

  end

  def final_instruction?
    @pc == @mem.size
  end

  def fetch
    @mem[@pc]
  end

  def run

    running = true
    set_initial_r0

    while running

      break if final_instruction?

      op_code, r1, r2, r3 = fetch # fetch the next instruction from memory
      instr_nil_check!([op_code, r1, r2, r3])

      begin
        ops(op_code).call(op_code, r1, r2, r3)
        debug(op_code, r1, r2, r3)
      rescue
        mangle_r0! # if the result failed, return a bad value to decrease fitness score
      end

      @pc += 1 # increment program counter

    end

    set_end_r0 # check the result saved as the return address

    mangle_r0_if_same! # mangle r0 to a bad value if the return value is the same as the initial value

    @r[0] = MAGIC_NUMBER if @r[0].class == Float && (@r[0].infinite? || @r[0].nan?)
    @r[0] = MAGIC_NUMBER if @r[0].class == Complex
    @r

  end

  def load(code)
    @mem = code
  end

  def set_initial_r0
    @r0_start = @r[0]
  end

  def set_end_r0
    @r0_end = @r[0]
  end

  def mangle_r0!
    @r[0] = MAGIC_NUMBER
  end

  def mangle_r0_if_same!
    @r[0] = MAGIC_NUMBER if @r0_start == @r0_end
  end

  def instr_nil_check!(instr)
    @r[0] = MAGIC_NUMBER if instr.nil?
  end

end
