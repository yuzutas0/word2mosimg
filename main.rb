# main class
class Main
  # ----------------------------------------
  # library
  # ----------------------------------------

  require_relative 'scripts/crawler'

  # ----------------------------------------
  # parameter
  # ----------------------------------------

  # TODO

  # set parameters
  def init(keyword)
    @keyword = keyword
  end

  # ----------------------------------------
  # main action
  # ----------------------------------------

  def execute
    # TODO: input keyword
    # todo validate

    # TODO: input goal_image
    # todo validate
    # todo convert to specific size and color

    # TODO: search images by keyword
    # todo convert to specific size and color

    Crawler.new.init.crawl_images @keyword

    # TODO: learn combination of images
    # todo convert goal_image to vector
    # todo convert images to vector(element)
    # todo convert each element to mean color
    # todo sort each element (or least squares method)

    # TODO: make image
    # todo connect images to one bigger image with sort result
    # todo export image file
  end

  # ----------------------------------------
  # sub action
  # ----------------------------------------

  # TODO
end

# initialize and execute
main = Main.new
main.init 'test'
# main.execute

require 'RMagick'
FILE_NAME = (Dir.pwd + '/assets/targets/zeta').freeze
FILE_SUFFIX = '.jpg'.freeze

img = Magick::ImageList.new(FILE_NAME + FILE_SUFFIX)
new_img = img.quantize(256, Magick::GRAYColorspace)
new_img.write(FILE_NAME + '_gray' + FILE_SUFFIX)

# not error 1500 * 1500
pixel = img.get_pixels(1499, 50, 1, 1)[0]
pixel_color = [255 * pixel.red / Magick::QuantumRange, 255 * pixel.green / Magick::QuantumRange, 255 * pixel.blue / Magick::QuantumRange]
puts pixel_color

# not error
pixel = img.pixel_color(-100000, 1500000)
pixel_color = [255 * pixel.red / Magick::QuantumRange, 255 * pixel.green / Magick::QuantumRange, 255 * pixel.blue / Magick::QuantumRange]
puts pixel_color

# error for 1500 * 1500
new_pixel = new_img.get_pixels(0, 0, 50, 1501)[0]
new_pixel_color = [255 * new_pixel.red / Magick::QuantumRange, 255 * new_pixel.green / Magick::QuantumRange, 255 * new_pixel.blue / Magick::QuantumRange]
puts new_pixel_color

img.destroy!
new_img.destroy!
