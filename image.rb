require 'forwardable'
require 'chunky_png'
require 'matrix'

class Image
  extend Forwardable

  delegate [:get_pixel, :set_pixel, :width, :height, :save] => :@png

  def self.from_file(filename)
    new(ChunkyPNG::Image.from_file(filename))
  end

  def initialize(png)
    @png = png
  end

  def get_block(radius, x, y)
    left = x - radius
    top  = y - radius

    Matrix.build(radius * 2 + 1) do |dy, dx|
      get_pixel(left + dx, top + dy)
    end
  end

  def each_block(radius)
    (radius .. (@png.width - radius) - 1).each do |x|
      (radius .. (@png.height - radius) - 1).each do |y|
        yield [x, y, get_block(radius, x, y)]
      end
    end
  end

  def convolve(matrix)
    each_block((matrix.row_size - 1) / 2) do |x, y, block|
      pixel_value = 0

      (0 .. matrix.row_size - 1).each do |x|
        (0 .. matrix.row_size - 1).each do |y|
          pixel_value += matrix[x, y] * block[x, y]
        end
      end

      yield pixel_value
    end
  end
end
