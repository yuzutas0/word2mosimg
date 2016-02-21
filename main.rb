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

    # same as browser
    # https://www.google.co.jp/search?q=test&tbm=isch
    response = search @keyword
    images = parse response
    save(images, ORIGINALS_PATH + 'test01/')

    # response similar to browser's pattern but not same
    response = search_file 'https://www.google.co.jp/search?q=test&tbm=isch&start=0'
    images = parse response
    save(images, ORIGINALS_PATH + 'test06/')

    # response similar to browser's pattern and test6, but not same
    response = search_file 'https://www.google.co.jp/search?q=test&tbm=isch&start=1'
    images = parse response
    save(images, ORIGINALS_PATH + 'test07/')


    # different response
    response = search_file 'https://www.google.co.jp/search?q=test&tbm=isch&start=19'
    images = parse response
    save(images, ORIGINALS_PATH + 'test10/')

    # different response
    response = search_file 'https://www.google.co.jp/search?q=test&tbm=isch&start=20'
    images = parse response
    save(images, ORIGINALS_PATH + 'test11/')

    # different response
    response = search_file 'https://www.google.co.jp/search?q=test&tbm=isch&start=21'
    images = parse response
    save(images, ORIGINALS_PATH + 'test12/')

    # result is ...
    #
    # 01 && 06 -> 18 / 20 is same element!
    # 01 && 07 -> 17 / 20 is same element!
    # 01 && 10 -> 0 / 20 is same element!
    # 01 && 11 -> 0 / 20 is same element!
    # 01 && 12 -> 1 / 20 is same element!
    #
    # 06 && 10 -> 1 / 20 is same element!
    # 06 && 11 -> 0 / 20 is same element!
    # 06 && 12 -> 0 / 20 is same element!
    #
    # 07 && 10 -> 1 / 20 is same element!
    # 07 && 11 -> 0 / 20 is same element!
    # 07 && 12 -> 0 / 20 is same element!

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

  # get text file from ajax I/O of google images
  def search_file(uri)
    request_uri = uri
    response = open(request_uri, &:read).toutf8
    response = Nokogiri::HTML('<html><head><title>dummy</title></head><body>' + response + '</body></html>')
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
  def save(images, path)
    images.each do |image|
      name = path + image.split(NAME_SEPARATOR)[1] + NAME_SUFFIX
      File.write(name, open(image, &:read))
    end
  end
end

# initialize and execute
main = Main.new
main.init 'test'
main.execute
