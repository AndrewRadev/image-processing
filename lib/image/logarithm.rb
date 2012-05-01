class Image
  module Logarithm
    def log_transform
      max_value = 0
      each_pixel do |x, y, pixel|
        intensity = Color.grayscale_intensity(pixel)
        max_value = intensity if max_value < intensity
      end

      scaling_factor = 255.0 / Math.log(1 + max_value)

      map_pixels do |x, y, pixel|
        intensity     = Color.grayscale_intensity(pixel)
        new_intensity = (scaling_factor * Math.log(1 + intensity)).round

        Color.grayscale(new_intensity)
      end
    end
  end
end
