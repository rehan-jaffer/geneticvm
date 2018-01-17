require 'pp'

class RASM
  def self.translate(program)
    prelude = "int candidate(int registers[]) {\n"
    prelude += program.map { |line|
      case line[0]
        when 1
          "r[#{line[1]}] = r[#{line[2]}] + r[#{line[3]}];"
        when 2
          "r[#{line[1]}] = r[#{line[2]}] - r[#{line[3]}];"
        when 3
          "r[#{line[1]}] = r[#{line[2]}] * r[#{line[3]}];"
        when 4
          "r[#{line[1]}] = r[#{line[2]}] / r[#{line[3]}];"
        when 5
          "r[#{line[1]}] = r[#{line[2]}] ** r[#{line[3]}];"
        when 6
          "r[#{line[1]}] = exp(r[#{line[2]}]);"
        when 7
          "r[#{line[1]}] = r[#{line[2]}] * r[#{line[3]}];"

      end  
    }.join("")
    prelude += "}\n"
  end
  def self.disasm(program)
    program.map { |line|
      case line[0]
        when 0
          "NOOP"
        when 1
          "r#{line[1]} = r#{line[2]} + r#{line[3]}"
        when 2
          "r#{line[1]} = r#{line[2]} - r#{line[3]}"
        when 3
          "r#{line[1]} = r#{line[2]} * r#{line[3]}"
        when 4
          "r#{line[1]} = r#{line[2]} / r#{line[3]}"
        when 5
          "r#{line[1]} = r#{line[2]} ** r#{line[3]}"
        when 6
          "r#{line[1]} = exp(r#{line[2]})"
        when 7
          "r#{line[1]} = Math.log(r#{line[2]})"
        when 8
          "r#{line[1]} = r#{line[2]}**2"
        when 9
          "r#{line[1]} = Math.sqrt(r#{line[2]})"
        when 10
          "r#{line[1]} = Math.sin(r#{line[2]})"
        when 11
          "r#{line[1]} = Math.cos(r#{line[2]})"
        when 12
          "IF (r#{line[1]} > r#{line[2]})"
        when 13
          "IF (r#{line[1]} <= r#{line[2]})"
       end
    }
  end
end
