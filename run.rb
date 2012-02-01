$: << File.expand_path('lib')

require 'pp'
require 'image'
require 'mask'

def time(text)
  print ">> #{text}... "
  start_time = Time.now

  result = yield

  end_time = Time.now
  puts "#{(end_time - start_time)}s"

  result
end

input = Image.from_file('image.png')
output = input.gaussian_blur

# mask = time 'Generating mask' do
#   Mask.new(input) do |x, y|
#     Color.grayscale_intensity(input.get_pixel(x, y)) < 255
#   end
# end
#
# output = time 'Dimming' do
#   input.map_pixels do |x, y, pixel|
#     intensity = Color.grayscale_intensity(pixel)
#     intensity *= 0.8
#     Color.grayscale(intensity.round)
#   end
# end
#
# output = time 'Applying mask' do
#   mask.apply(output, Color.rgb(255, 255, 255))
# end

puts '>> Saving...'
output.save('image_processed.png', :fast_rgba)
