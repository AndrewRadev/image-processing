require 'core_ext/array'
require 'core_ext/matrix'

class Image
  module Threshold
    def threshold(value)
      output = blank_copy
      each_pixel { |x, y, pixel| output.set_pixel(x, y, threshold_pixel(pixel, value)) }
      output
    end

    def iterative_threshold(current_threshold_value = 128)
      previous_threshold_value = nil

      while current_threshold_value != previous_threshold_value
        background = []
        foreground = []

        each_pixel do |x, y, pixel|
          value = Color.grayscale_intensity(pixel)

          if value > current_threshold_value
            foreground << value
          else
            background << value
          end
        end

        previous_threshold_value = current_threshold_value
        current_threshold_value = ((foreground.average + background.average) / 2).round
      end

      threshold(current_threshold_value)
    end

    def adaptive_threshold(radius, adjustment, method = :mean)
      output = blank_copy

      each_block(radius) do |x, y, block|
        block = block.map { |pixel| Color.grayscale_intensity(pixel) }
        value = block.send(method) - adjustment
        pixel = get_pixel(x, y)

        output.set_pixel(x, y, threshold_pixel(pixel, value))
      end

      output
    end

    private

    def threshold_pixel(pixel, value)
      if Color.grayscale_intensity(pixel) > value
        Color.grayscale(255)
      else
        Color.grayscale(0)
      end
    end
  end
end
