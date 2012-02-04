require './task'

subject  = Image.from_file('image_foreground.png')
clusters = Image.from_file('image_cluster_map.png')

subject_count = 0
bump_count    = 0

subject.each_pixel do |x, y, value|
  intensity = Color.grayscale_intensity(value)
  subject_count += 1 if intensity > 0
end

clusters.each_pixel do |x, y, value|
  intensity = Color.grayscale_intensity(value)
  bump_count += 1 if intensity == 0
end

puts bump_count
puts subject_count
puts bump_count.to_f / subject_count
