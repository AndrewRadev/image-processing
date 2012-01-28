class Image
  module Histogram
    def histogram
      @histogram ||= calculate_histogram
    end

    def grayscale_intensity(x, y)
      ChunkyPNG::Color.to_grayscale_bytes(get_pixel(x, y)).first
    end

    private

    def calculate_histogram
      data = {}
      data.default = 0

      each_pixel do |x, y|
        data[grayscale_intensity(x, y)] += 1
      end

      data
    end
  end
end
