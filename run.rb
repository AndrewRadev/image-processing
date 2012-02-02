require './task'

# edges = Image.from_file('image_edges.png')
# image = Image.from_file('image.png')
#
# mask   = Task.foreground_mask(edges, image)
# output = Task.threshold(image, mask)

input = Image.from_file('image_thresholded.png')
output = input.gaussian_blur.iterative_threshold

output.save('image_processed.png', :fast_rgba)
