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

    # target file into 200 * 200 gray scaled
    Reductor.new.init.target

    # search images by keyword
    Crawler.new.init.crawl_images @keyword

    # TODO: convert to specific size and color

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
require 'uri'
keyword = URI.escape '愛'
main = Main.new
main.init keyword
main.execute
