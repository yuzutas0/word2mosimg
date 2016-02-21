# main class
class Main
  # ----------------------------------------
  # library
  # ----------------------------------------

  require 'open-uri'
  require 'kconv'
  require 'nokogiri'

  # ----------------------------------------
  # parameter
  # ----------------------------------------

  def init
    @keyword = 'test'
  end

  # ----------------------------------------
  # main action
  # ----------------------------------------

  def execute
    puts @keyword

    # TODO: input keyword
    # todo validate

    # TODO: input goal_image
    # todo validate
    # todo convert to specific size and color

    # TODO: search images by keyword
    # todo convert to specific size and color

    request_uri = 'https://www.ruby-lang.org/en'
    response = Nokogiri::HTML(open(request_uri, &:read).toutf8)
    sleep(2)
    puts response.at('//*[@id="intro"]/p').text

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
main = Main.new
main.init
main.execute
