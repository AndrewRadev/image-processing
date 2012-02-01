class Mask
  def initialize(image, &block)
    block ||= proc { false }
    @mask = Matrix.build(image.width, image.height, &block)
  end

  def [](x, y)
    @mask[x, y]
  end

  def add(x, y)
    @mask.send(:[]=, x, y, true)
  end

  def remove(x, y)
    @mask.send(:[]=, x, y, false)
  end

  def width
    @mask.row_size
  end

  def height
    @mask.column_size
  end

  def each_pixel
    @mask.each_with_index do |value, x, y|
      yield [x, y, value]
    end
  end

  def apply(image, color = Color.rgb(0, 0, 0))
    result = image.dup

    each_pixel do |x, y, keep|
      if not keep
        result.set_pixel(x, y, color)
      end
    end

    result
  end

  def &(other)
    Mask.new(other) do |x, y|
      self[x, y] || other[x, y]
    end
  end

  def ~@
    Mask.new(self) do |x, y|
      not self[x, y]
    end
  end
end
