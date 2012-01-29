$: << File.expand_path('lib')

require 'pp'
require 'image'

puts '>> Opening image...'
input = Image.from_file('image.png')

puts '>> Processing...'
output = input.normalize_histogram.iterative_threshold

puts '>> Saving...'
output.save('image_processed.png', :fast_rgba)
