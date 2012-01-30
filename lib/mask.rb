require 'forwardable'
require 'image'

class Mask
  extend Forwardable

  def initialize(image, &block)
    @mask = Matrix.build(image.width, image.height, &block)
  end

  def each_pixel
    @mask.each_with_index do |value, x, y|
      yield [x, y, value]
    end
  end

  def apply(image)
    result = image.dup

    each_pixel do |x, y, keep|
      if not keep
        result.set_pixel(x, y, Color.rgb(0, 0, 0))
      end
    end

    result
  end
end
