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

  SEARCH_WORD_PREFIX = 'https://www.google.co.jp/search?tbm=isch&q='.freeze
  SEARCH_IMAGE_REGEX = %r{^https://encrypted-tbn}

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

    response = search @keyword
    image_url_list = extract_image_url_list response
    puts 'array: ' + image_url_list.length.to_s

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

  def search(keyword)
    request_uri = SEARCH_WORD_PREFIX + keyword
    response = Nokogiri::HTML(open(request_uri, &:read).toutf8)
    sleep(2)
    response
  end

  def extract_image_url_list(response)
    image_url_list = []
    response.search('img').each do |img|
      image_url_list << img['src'] if SEARCH_IMAGE_REGEX =~ img['src']
    end
    image_url_list
  end
end

# initialize and execute
main = Main.new
main.init 'test'
# main.execute
