class Array
  def sum
    inject(:+)
  end

  def average
    sum.to_f / count
  end
end
