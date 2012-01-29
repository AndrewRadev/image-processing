require 'matrix'

class Matrix
  def sum
    result = 0
    each { |value| result += value }
    result
  end

  def average
    sum.to_f / (row_size * column_size)
  end
end
