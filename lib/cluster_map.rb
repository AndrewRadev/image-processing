class ClusterMap
  def initialize(image)
    @image    = image
    @mapping  = Matrix.build(image.width, image.height) { nil }
    @clusters = []
  end

  def clusters
    @image.each_pixel do |x, y, value|
      intensity = Color.grayscale_intensity(value)

      next if intensity > 0
      next if @mapping[x, y]

      found_cluster = nil

      [
        [x - 1, y], [x + 1, y],
        [x, y - 1], [x, y + 1],
        [x + 1, y + 1], [x - 1, y - 1],
        [x + 1, y - 1], [x - 1, y + 1],
      ].each do |xy|
        neighbour_cluster = @mapping[xy[0], xy[1]]
        if neighbour_cluster
          found_cluster = neighbour_cluster
          found_cluster.add(*xy)
          @mapping[x, y] = found_cluster
          break
        end
      end

      if not found_cluster
        new_cluster = Cluster.new([x, y])
        @clusters << new_cluster
        @mapping[x, y] = new_cluster
      end
    end

    @clusters
  end

  private

  class Cluster
    attr_reader :right_margin

    def initialize(xy)
      @pixels = Set.new
      @pixels.add xy
      @right_margin = xy[0]
    end

    def add(x, y)
      @pixels.add [x, y]
      @right_margin = x if x > @right_margin
    end

    def include?(x, y)
      @pixels.include?([x, y])
    end

    def size
      @pixels.size
    end

    def each_pixel
      @pixels.each do |xy|
        yield [xy[0], xy[1]]
      end
    end
  end
end
