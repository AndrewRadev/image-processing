require 'chunky_png'

class Color
  extend ChunkyPNG::Color

  def self.grayscale_intensity(pixel)
    to_grayscale_bytes(pixel).first
  end
end
