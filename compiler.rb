require 'pp'

class Compiler

  def initialize(program)
    @program = program
  end

  def header_code
    ret = ""
    ret += "r = initial_registers;\r\n"  
    ret += "r += Array.new(256, 0)\r\n"
    ret
  end

  def translate_rb
    cid = rand(0..512)
    @c_program = "def candidate(initial_registers=[])\r\n"
    @c_program += header_code
    @c_program += @program.map { |line|
      case line[0]
        when 0
          "r[0] = r[0];\r\n"
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
    @c_program += "return r;\nend\r\n"
    @c_program
  end

  def translate_c
    @c_program = "int candidate(int registers) {\n"
    @c_program += "double r[256];\r\n"
    @c_program += @program.map { |line|
      case line[0]
        when 0
          "r[0] = r[0];\r\n"
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
    @c_program += "return registers; }\n"
    @c_program
  end

  def compile(code)
    pp code
    t = c.new
    t.candidate(0)
  end

  def run(input, output)
  end

end
