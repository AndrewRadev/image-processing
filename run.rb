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

# input = Image.from_file('image_edges.png')
# output = input.iterative_threshold
# output.save('image_processed.png', :fast_rgba)

input = Image.from_file('image_edges.png')
real_image = Image.from_file('image.png')

upper_mask = Mask.new(input)
(5 ... input.width - 5).each do |x|
  (5 ... input.height - 5).each do |y|
    pixel = input.get_pixel(x, y)
    break if Color.grayscale_intensity(pixel) == 255
    upper_mask.add(x, y)
  end
end

lower_mask = Mask.new(input)
(5 ... input.width - 5).each do |x|
  (5 ... input.height - 5).reverse_each do |y|
    pixel = input.get_pixel(x, y)
    break if Color.grayscale_intensity(pixel) == 255
    lower_mask.add(x, y)
  end
end

mask = ~(upper_mask & lower_mask)

mask.apply(real_image).save('image_foreground.png', :fast_rgba)
