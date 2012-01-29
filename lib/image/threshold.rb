require 'core_ext/array'
require 'core_ext/matrix'

class Image
  module Threshold
    def threshold(value)
      output = dup
      each_pixel { |x, y| output.threshold_pixel(x, y, value) }
      output
    end

    def iterative_threshold(current_threshold_value = 128)
      previous_threshold_value = nil

      while current_threshold_value != previous_threshold_value
        background = []
        foreground = []

        each_pixel do |x, y|
          value = grayscale_intensity(x, y)

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

    def adaptive_threshold(radius = 5, adjustment = 0)
      output = dup
      each_block(radius) do |x, y, block|
        block = block.map { |pixel| Color.to_grayscale_bytes(pixel).first }
        output.threshold_pixel(x, y, block.average - adjustment)
      end
      output
    end

    protected

    def threshold_pixel(x, y, value)
      if grayscale_intensity(x, y) > value
        set_pixel(x, y, Color.grayscale(255))
      else
        set_pixel(x, y, Color.grayscale(0))
      end
    end
  end
end
