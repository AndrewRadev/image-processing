$: << File.expand_path('lib')

require 'pp'
require 'image'
require 'mask'

puts '>> Opening image...'
input = Image.from_file('image.png')
mask = Mask.new(input) do |x, y|
  Color.grayscale_intensity(input.get_pixel(x, y)) < 255
end

puts '>> Processing...'
output = mask.apply(input).mean_adaptive_threshold(7, 2)

puts '>> Saving...'
output.save('image_processed.png', :fast_rgba)
