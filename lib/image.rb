require 'forwardable'
require 'chunky_png'
require 'matrix'

require 'image/filters'
require 'image/histogram'
require 'image/threshold'
require 'image/contrast'
require 'image/logarithm'
require 'color'

class Image
  include Filters
  include Histogram
  include Threshold
  include Contrast
  include Logarithm

  extend Forwardable
  delegate [:get_pixel, :set_pixel, :[], :[]=, :width, :height, :save] => :@png

  def self.from_file(filename)
    new(ChunkyPNG::Image.from_file(filename))
  end

  def initialize(png)
    @png = png
  end

  def dup
    Image.new(@png.dup)
  end

  def blank_copy
    Image.new(ChunkyPNG::Image.new(width, height, ChunkyPNG::Color::WHITE))
  end

  def each_pixel
    (0 ... @png.width).each do |x|
      (0 ... @png.height).each do |y|
        yield [x, y, get_pixel(x, y)]
      end
    end
  end

  def modify_intensity(x, y)
    if @png.include_xy?(x, y)
      new_value = yield Color.grayscale_intensity(get_pixel(x, y))
      self.set_pixel(x, y, Color.grayscale(new_value))
    end
  end

  def map_pixels
    output = blank_copy

    each_pixel do |x, y, pixel|
      new_pixel = yield [x, y, pixel]
      output.set_pixel(x, y, new_pixel)
    end

    output
  end

  def each_block(radius)
    block_size = radius * 2 + 1

    (radius .. (width - radius) - 1).each do |x|
      (radius .. (height - radius) - 1).each do |y|
        left = x - radius
        top  = y - radius

        block = Matrix.build(block_size) do |dx, dy|
          get_pixel(left + dx, top + dy)
        end

        yield [x, y, block]
      end
    end
  end
end
