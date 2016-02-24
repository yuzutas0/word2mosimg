# main class
class Main
  # ----------------------------------------
  # library
  # ----------------------------------------

  require_relative 'scripts/crawler'
  require_relative 'scripts/reductor'

  # ----------------------------------------
  # parameter
  # ----------------------------------------

  def init(keyword)
    @keyword = keyword
  end

  # ----------------------------------------
  # main action
  # ----------------------------------------

  def execute
    # reductor = Reductor.new.init
    #
    # # target file into 200 * 200 gray scaled
    # reductor.target
    #
    # # search images by keyword
    # Crawler.new.init.crawl_images @keyword
    #
    # # original images into 100 * 100 gray scaled
    # reductor.element
    #
    # # element images into 1 * 1 to learn
    # reductor.pixel

    Reductor.new.init.diff_colors

    # TODO: learn combination of images
    # todo convert goal_image to vector
    # todo convert images to vector(element)
    # todo convert each element to mean color
    # todo sort each element (or least squares method)

    # TODO: make image
    # todo connect images to one bigger image with sort result
    # todo export image file
  end
end

# initialize and execute
require 'uri'
keyword = URI.escape '愛'
main = Main.new
main.init keyword
main.execute


