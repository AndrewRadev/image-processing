require 'forwardable'
require 'chunky_png'
require 'matrix'

require 'image/filters'

class Image
  include Filters

  extend Forwardable
  delegate [:get_pixel, :set_pixel, :width, :height, :save] => :@png

  def self.from_file(filename)
    new(ChunkyPNG::Image.from_file(filename))
  end

  def initialize(png)
    @png = png
  end

  def dup
    Image.new(@png.dup)
  end
end
