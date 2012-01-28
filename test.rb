$: << File.expand_path('lib')

require 'image'

puts '>> Opening image...'
input = Image.from_file('image.png')

puts '>> Processing...'
output = input.sobel

puts '>> Saving...'
output.save('image_processed.png', :fast_rgba)
