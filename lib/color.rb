require 'chunky_png'

class Color
  extend ChunkyPNG::Color

  WHITE = rgb(255, 255, 255)
  BLACK = rgb(0, 0, 0)

  def self.grayscale_intensity(pixel_value)
    # assumption: r == g == b
    (pixel_value & 0x0000ff00) >> 8
  end
end
