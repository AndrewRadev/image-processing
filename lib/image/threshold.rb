require 'core_ext/array'

class Image
  module Threshold
    def threshold(value)
      output = dup

      each_pixel do |x, y|
        if grayscale_intensity(x, y) >= value
          output.set_pixel(x, y, Color.grayscale(255))
        else
          output.set_pixel(x, y, Color.grayscale(0))
        end
      end

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
  end
end
