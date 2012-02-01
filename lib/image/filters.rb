require 'matrix'
require 'chunky_png'

class Image
  module Filters
    def mean_blur(size)
      value  = 1.0 / (size * size)
      matrix = Matrix.build(size) { value }

      convolve(matrix)
    end

    def gaussian_blur
      matrix = 1/273.0 * Matrix[
        [1, 4,  7,  4,  1],
        [4, 16, 26, 16, 4],
        [7, 26, 41, 26, 7],
        [4, 16, 26, 16, 4],
        [1, 4,  7,  4,  1]
      ]

      convolve(matrix)
    end

    def laplacian
      matrix = Matrix[
        [-1, -1, -1],
        [-1, 8,  -1],
        [-1, -1, -1]
      ]

      convolve(matrix)
    end

    def sobel
      sobel_x = Matrix[ [-1,0,1], [-2,0,2], [-1,0,1] ]
      sobel_y = Matrix[ [-1,-2,-1], [0,0,0], [1,2,1] ]

      output = blank_copy

      each_block(1) do |x, y, block|
        pixel_x = 0
        pixel_y = 0

        (0 .. 2).each do |x|
          (0 .. 2).each do |y|
            pixel_x += sobel_x[x, y] * Color.to_grayscale_bytes(block[x, y]).first
            pixel_y += sobel_y[x, y] * Color.to_grayscale_bytes(block[x, y]).first
          end
        end

        new_pixel = Math.sqrt(pixel_x * pixel_x + pixel_y * pixel_y).ceil
        new_pixel = Color.grayscale(new_pixel)

        output.set_pixel(x, y, new_pixel)
      end

      output
    end

    private

    def convolve(matrix)
      output = blank_copy

      each_block(matrix.row_size / 2) do |x, y, block|
        r, g, b = 0, 0, 0

        matrix.each_with_index do |value, row, col|
          r += value * Color.r(block[row, col])
          g += value * Color.g(block[row, col])
          b += value * Color.b(block[row, col])
        end

        output.set_pixel(x, y, Color.rgb(r.round, g.round, b.round))
      end

      output
    end
  end
end
