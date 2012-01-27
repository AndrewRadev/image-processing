require 'pp'
require 'matrix'
require './image'

puts '>> Opening image...'
input = Image.from_file('valve.png')
output = ChunkyPNG::Image.new(input.width, input.height, ChunkyPNG::Color::TRANSPARENT)

sobel_x = Matrix[
  [-1,0,1],
  [-2,0,2],
  [-1,0,1]
]

sobel_y = Matrix[
  [-1,-2,-1],
  [0,0,0],
  [1,2,1]
]

input.each_block(1) do |x, y, block|
  pixel_x = 0
  pixel_y = 0

  (0 .. 2).each do |x|
    (0 .. 2).each do |y|
      pixel_x += sobel_x[x, y] * ChunkyPNG::Color.to_grayscale_bytes(block[x, y]).first
      pixel_y += sobel_y[x, y] * ChunkyPNG::Color.to_grayscale_bytes(block[x, y]).first
    end
  end

  new_pixel = Math.sqrt(pixel_x * pixel_x + pixel_y * pixel_y).ceil
  new_pixel = ChunkyPNG::Color.grayscale(new_pixel)

  output.set_pixel(x, y, new_pixel)
end

puts '>> Saving...'
output.save('valve_processed.png', :fast_rgb)
