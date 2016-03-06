# main class
class Main
  # ----------------------------------------
  # library
  # ----------------------------------------

  require_relative 'scripts/crawler'
  require_relative 'scripts/reductor'
  require_relative 'scripts/analyzer'
  require_relative 'scripts/divider'
  require_relative 'scripts/combiner'
  require_relative 'scripts/drawer'

  # ----------------------------------------
  # parameter
  # ----------------------------------------

  def init(keywords)
    @keywords = keywords
    self
  end

  # ----------------------------------------
  # main action
  # ----------------------------------------

  def execute
    input_images(@keywords)
    output_images
  end

  # crawl and reduce images
  def input_images(keywords)
    reductor = Reductor.new.init
    # target file into 200 * 200 gray scaled
    reductor.target
    # search images by keyword
    keywords.each { |keyword| Crawler.new.init.crawl_images keyword }
    # original images into 100 * 100 gray scaled
    reductor.element
    # element images into 1 * 1 to learn
    reductor.pixel
  end

  # learn and combine, export mosaic image
  def output_images
    # analyze color diff of target and pixel files
    Analyzer.new.init.diff_colors
    # divide target and pixel colors to 8 pattern
    Divider.new.init.divide
    # combine target colors and element files
    Combiner.new.init.combine
    # draw mosaic image - simple connect / resize
    Drawer.new.init.draw
  end
end

# initialize and execute
require 'uri'
keywords = [URI.escape('愛'), URI.escape('love')]
Main.new.init(keywords).execute
