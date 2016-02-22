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

# resize
width = height = 200
resized_img = img.resize(width, height)

# gray scale
new_img = resized_img.quantize(256, Magick::GRAYColorspace)
new_img.write(FILE_NAME + '_new' + FILE_SUFFIX)

img.destroy!
resized_img.destroy!
new_img.destroy!
