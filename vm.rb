require 'pp'

DEBUG_MODE = false

class UnimplementedOpcode < StandardError
end

class VM
  def initialize(registers=[])
    @r = registers + Array.new(8, 0)
    @pc = 0
  end

  def load(code)
    @mem = code
  end

  def registers
    @r
  end

  def run
    running = true
    while running
      break if @pc >= @mem.size
      instr = @mem[@pc]
      op_code, r1, r2, r3, data = instr[0], instr[1], instr[2], instr[3], instr[4]
      case op_code
        when 0
          # NOOP
          @pc += 1
          puts "NOOP" if DEBUG_MODE
        when 1
          @r[r1] = @r[r2] + @r[r3]; @pc += 1;
          puts "ADD R#{r1}, #{data}" if DEBUG_MODE
        when 2
          @r[r1] = @r[r2] - @r[r3]; @pc += 1;
        when 3
          @r[r1] = @r[r2] * @r[r3]; @pc += 1;
        when 4
          @r[r1] = @r[r2] / @r[r3]; @pc += 1;
        when 5
          @r[r1] = @r[r2] ** @r[r3]; @pc += 1;
        else
          pp instr
          raise UnimplementedOpcode
      end
    end

    @r

  end
end
