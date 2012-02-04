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
      output = dup

      each_block(radius) do |x, y, block|
        block = block.map { |pixel| Color.grayscale_intensity(pixel) }
        value = block.send(method) - adjustment
        pixel = get_pixel(x, y)

        output.set_pixel(x, y, threshold_pixel(pixel, value))
      end

      output
    end

    def floyd_steinberg_threshold(value)
      output = dup

      (0 ... height).each do |y|
        (0 ... width).each do |x|
          original_intensity = Color.grayscale_intensity(get_pixel(x, y))
          if original_intensity < value
            new_intensity = 0
          else
            new_intensity = 255
          end

          error = original_intensity - value

          output.modify_intensity(x + 1, y)     { |v| (v + 7/16.0 * error).round }
          output.modify_intensity(x - 1, y + 1) { |v| (v + 3/16.0 * error).round }
          output.modify_intensity(x,     y + 1) { |v| (v + 5/16.0 * error).round }
          output.modify_intensity(x + 1, y + 1) { |v| (v + 1/16.0 * error).round }
        end
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
