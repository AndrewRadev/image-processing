$: << File.expand_path('lib')

require 'pp'
require 'image'

puts '>> Opening image...'
input = Image.from_file('image.png')

puts '>> Processing...'

histogram = input.histogram
cumulative_distribution = {}

histogram.each do |value, count|
  significant_values = histogram.select { |k, v| k <= value }.to_a.map(&:last)
  cumulative_distribution[value] = significant_values.inject(:+)
end

min_intensity = cumulative_distribution.to_a.min.last

output = input.dup
pixel_count = input.width * input.height
input.each_pixel do |x, y|
  intensity = input.grayscale_intensity(x, y)
  new_value = (((cumulative_distribution[intensity] - min_intensity) / pixel_count.to_f) * 255).round
  output.set_pixel(x, y, ChunkyPNG::Color.grayscale(new_value))
end

# pp hist.to_a.sort
# pp hist.values.inject(:+) / 255.0

# output = input.sobel
#
puts '>> Saving...'
output.save('image_processed.png', :fast_rgba)
