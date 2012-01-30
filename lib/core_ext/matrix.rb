require 'matrix'

class Matrix
  def count
    row_size * column_size
  end

  def sum
    result = 0
    each { |value| result += value }
    result
  end

  def average
    sum.to_f / count
  end
  alias_method :mean, :average

  def median
    rows.sum.compact.sort[count / 2]
  end
end
