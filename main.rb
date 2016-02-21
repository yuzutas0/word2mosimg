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

  # request for google images
  SEARCH_PREFIX = 'https://www.google.co.jp/search?tbm=isch&q='.freeze

  # regex for image links
  IMAGES_PROTOCOL = 'https:\/\/'.freeze
  IMAGES_DOMAIN = 'encrypted-tbn(0|1|2|3)\.gstatic\.com\/images'.freeze
  IMAGES_QUERY = '\?q=tbn:.{50,70}'.freeze
  IMAGES_REGEX = /^#{IMAGES_PROTOCOL + IMAGES_DOMAIN + IMAGES_QUERY}$/

  # name, directory for save images
  NAME_SEPARATOR = 'images?q=tbn:'.freeze
  NAME_SUFFIX = '.jpg'.freeze
  ASSETS_PATH = (Dir.pwd + File::SEPARATOR + 'assets' + File::SEPARATOR).freeze
  ORIGINALS_PATH = (ASSETS_PATH + 'originals' + File::SEPARATOR).freeze

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

    response = search @keyword
    images = parse response
    save images

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

  # get Nokogiri::HTML object after search google images with keyword
  def search(keyword)
    request_uri = SEARCH_PREFIX + keyword
    response = Nokogiri::HTML(open(request_uri, &:read).toutf8)
    sleep(2)
    response
  end

  # extract url list about images from response Nokogiri::HTML object
  def parse(response)
    array = []
    response.search('img').each do |img|
      array << img['src'] if IMAGES_REGEX =~ img['src']
    end
    array
  end

  # save original images
  def save(images)
    images.each do |image|
      name = ORIGINALS_PATH + image.split(NAME_SEPARATOR)[1] + NAME_SUFFIX
      File.write(name, open(image, &:read))
    end
  end
end

# initialize and execute
main = Main.new
main.init 'test'
main.execute

# ---------------------------------------------------
# https://www.google.co.jp/search?q=test&tbm=isch
# ---------------------------------------------------
# https://www.google.co.jp/search?
#
# q=test
# tbm=isch
# ---------------------------------------------------
# https://www.google.co.jp/async/irc?async=iu:0,_id:irc_async,_pms:s&vet=10ahUKEwirk7u3iInLAhVje6YKHXJNBaQQo0EIPg..i&ved=0ahUKEwirk7u3iInLAhVje6YKHXJNBaQQo0EIPg&yv=2
# ---------------------------------------------------
# https://www.google.co.jp/async/irc?
#
# async=iu:0,_id:irc_async,_pms:s
# vet=10ahUKEwirk7u3iInLAhVje6YKHXJNBaQQo0EIPg..i
# ved=0ahUKEwirk7u3iInLAhVje6YKHXJNBaQQo0EIPg
# yv=2

# ---------------------------------------------------
# https://www.google.co.jp/search?q=test&tbm=isch&ijn=1&ei=IMbJVs6BEMbEmwWV4bfIAg&start=100&ved=0ahUKEwjOkaebhYnLAhVG4qYKHZXwDSkQuT0IISgB&vet=10ahUKEwjOkaebhYnLAhVG4qYKHZXwDSkQuT0IISgB.IMbJVs6BEMbEmwWV4bfIAg.i
# ---------------------------------------------------
# https://www.google.co.jp/search?
#
# q=test
# tbm=isch
# ijn=1
# ei=IMbJVs6BEMbEmwWV4bfIAg
# start=100
# ved=0ahUKEwjOkaebhYnLAhVG4qYKHZXwDSkQuT0IISgB
# vet=10ahUKEwjOkaebhYnLAhVG4qYKHZXwDSkQuT0IISgB.IMbJVs6BEMbEmwWV4bfIAg.i

# ---------------------------------------------------
# https://www.google.co.jp/search?q=test&tbm=isch&ijn=2&ei=IMbJVs6BEMbEmwWV4bfIAg&start=200&ved=0ahUKEwjOkaebhYnLAhVG4qYKHZXwDSkQuT0IISgB&vet=10ahUKEwjOkaebhYnLAhVG4qYKHZXwDSkQuT0IISgB.IMbJVs6BEMbEmwWV4bfIAg.i
# ---------------------------------------------------
# https://www.google.co.jp/search?
#
# q=test
# tbm=isch
# ijn=2
# ei=IMbJVs6BEMbEmwWV4bfIAg
# start=200
# ved=0ahUKEwjOkaebhYnLAhVG4qYKHZXwDSkQuT0IISgB
# vet=10ahUKEwjOkaebhYnLAhVG4qYKHZXwDSkQuT0IISgB.IMbJVs6BEMbEmwWV4bfIAg.i
