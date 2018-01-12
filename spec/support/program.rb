def valid_program(len)
  len.times.map { |_| [rand(0..11), rand(0..15), rand(0..15), rand(0..15)] }
end
