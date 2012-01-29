class Image
  module Histogram
    def histogram
      @histogram ||= calculate_histogram
    end

    def cumulative_distribution
      @cumulative_distribution ||= calculate_cumulative_distribution
    end

    def normalize_histogram
      pixel_count   = width * height
      min_intensity = cumulative_distribution.to_a.min[1]
      output        = dup

      each_pixel do |x, y|
        intensity = grayscale_intensity(x, y)
        new_value = (((cumulative_distribution[intensity] - min_intensity) / pixel_count.to_f) * 255).round
        output.set_pixel(x, y, Color.grayscale(new_value))
      end

      output
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

    def calculate_cumulative_distribution
      data = {}

      sum_so_far = 0
      histogram.to_a.sort.each do |value, count|
        sum_so_far += count
        data[value] = sum_so_far
      end

      data
    end
  end
end
