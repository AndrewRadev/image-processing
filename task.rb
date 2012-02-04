$: << File.expand_path('lib')

require 'image'
require 'mask'
require 'cluster_map'

module Task
  extend self

  def edges(image)
    image.gaussian_blur.laplacian.mean_blur(3).mean_blur(3).iterative_threshold
  end

  def foreground_mask(edges)
    upper_mask = Mask.new(edges)
    (5 ... edges.width - 5).each do |x|
      (5 ... edges.height - 5).each do |y|
        pixel = edges.get_pixel(x, y)
        break if Color.grayscale_intensity(pixel) == 255
        upper_mask.add(x, y)
      end
    end
    add_edges(edges, upper_mask, 5)

    lower_mask = Mask.new(edges)
    (5 ... edges.width - 5).each do |x|
      (5 ... edges.height - 5).reverse_each do |y|
        pixel = edges.get_pixel(x, y)
        if Color.grayscale_intensity(pixel) == 255
          (0 ... 10).each do |dy|
            lower_mask.add(x, y - dy)
          end
          break
        end
        lower_mask.add(x, y)
      end
    end
    add_edges(edges, lower_mask, 5)

    ~(upper_mask & lower_mask)
  end

  def threshold(image, mask)
    image = image.map_intensity(0.8)
    image = mask.apply(image, Color::WHITE)
    image = image.adaptive_threshold(7, 2)
  end

  private

  def add_edges(image, mask, count)
    (0 ... image.width).each do |x|
      (0 ... count).each do |y|
        mask.add(x, y)
        mask.add(x, image.height - (y + 1))
      end
    end

    (0 ... image.height).each do |y|
      (0 ... count).each do |x|
        mask.add(x, y)
        mask.add(image.width - (x + 1), y)
      end
    end
  end
end
