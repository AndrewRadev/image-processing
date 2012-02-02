class Image
  module Contrast
    def map_intensity(ratio)
      map_pixels do |x, y, pixel|
        intensity = Color.grayscale_intensity(pixel)
        Color.grayscale((intensity * ratio).round)
      end
    end
  end
end
