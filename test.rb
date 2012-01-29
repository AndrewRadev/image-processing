$: << File.expand_path('lib')

require 'pp'
require 'image'

puts '>> Opening image...'
input = Image.from_file('image_normalized.png')

puts '>> Processing...'
output = input.adaptive_threshold(10, 5)

puts '>> Saving...'
output.save('image_processed.png', :fast_rgba)
