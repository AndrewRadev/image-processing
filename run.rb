require './task'

puts '>> Opening...'
image = Image.from_file('image.png')

puts '>> Edges...'
image = image.gaussian_blur.laplacian.iterative_threshold
image.save('image_edges.png', :fast_rgba)
image = Image.from_file('image_edges.png')

puts '>> Foreground...'
mask = Task.foreground_mask(image)
image = Image.from_file('image.png')
image = mask.apply(image)
image.save('image_foreground.png', :fast_rgba)

puts '>> Threshold...'
# image = Image.from_file('image_foreground.png')
image = image.adaptive_threshold(7, 2)
image.save('image_thresholded.png', :fast_rgba)

puts '>> Clean up...'
image = image.gaussian_blur.iterative_threshold
image.save('image_cleaned.png', :fast_rgba)

puts '>> Removing edge...'
image = mask.apply(image, Color::WHITE)
image.save('image_final.png', :fast_rgba)

puts '>> Clusterizing...'
cluster_map = ClusterMap.new(image)
clusters = cluster_map.clusters.reject { |c| c.size < 15 }

image = image.blank_copy
clusters.each do |cluster|
  cluster.each_pixel do |x, y|
    image.set_pixel(x, y, Color::BLACK)
  end
end
image.save('image_cluster_map.png', :fast_rgba)
