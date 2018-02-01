module VirtualMachine
  module Translation

  def self.disasm(code)
    Compiler.new(code).translate_rb
  end

  end
end
