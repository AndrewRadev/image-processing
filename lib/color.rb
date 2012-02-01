require 'chunky_png'

class Color
  extend ChunkyPNG::Color

  def self.grayscale_intensity(pixel_value)
    # assumption: r == g == b
    (pixel_value & 0x0000ff00) >> 8
  end
end
