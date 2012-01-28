require 'matrix'
require 'chunky_png'

class Image
  module Filters
    def blur
      convolve(mean_filter(3))
    end

    def sobel
      sobel_x = Matrix[ [-1,0,1], [-2,0,2], [-1,0,1] ]
      sobel_y = Matrix[ [-1,-2,-1], [0,0,0], [1,2,1] ]

      output = dup
      each_block(1) do |x, y, block|
        pixel_x = 0
        pixel_y = 0

        (0 .. 2).each do |x|
          (0 .. 2).each do |y|
            pixel_x += sobel_x[x, y] * ChunkyPNG::Color.to_grayscale_bytes(block[x, y]).first
            pixel_y += sobel_y[x, y] * ChunkyPNG::Color.to_grayscale_bytes(block[x, y]).first
          end
        end

        new_pixel = Math.sqrt(pixel_x * pixel_x + pixel_y * pixel_y).ceil
        new_pixel = ChunkyPNG::Color.grayscale(new_pixel)

        output.set_pixel(x, y, new_pixel)
      end

      output
    end

    private

    def each_block(radius)
      block_size = radius * 2 + 1

      (radius .. (@png.width - radius) - 1).each do |x|
        (radius .. (@png.height - radius) - 1).each do |y|
          left = x - radius
          top  = y - radius

          block = Matrix.build(block_size) do |dx, dy|
            @png.get_pixel(left + dx, top + dy)
          end

          yield [x, y, block]
        end
      end
    end

    def convolve(matrix)
      output = ChunkyPNG::Image.new(@png.width, @png.height)

      each_block(matrix.row_size / 2) do |x, y, block|
        r, g, b = 0, 0, 0

        matrix.each_with_index do |value, row, col|
          r += value * ChunkyPNG::Color.r(block[row, col])
          g += value * ChunkyPNG::Color.g(block[row, col])
          b += value * ChunkyPNG::Color.b(block[row, col])
        end

        output.set_pixel(x, y, ChunkyPNG::Color.rgb(r.round, g.round, b.round))
      end

      output
    end

    def mean_filter(n)
      value = 1.0 / (n ** 2)
      Matrix.build(n) { value }
    end
  end
end
