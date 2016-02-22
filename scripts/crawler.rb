# crawler class
class Crawler
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
  SEARCH_QUERY_PREFIX = 'https://www.google.co.jp/search?q='.freeze
  SEARCH_START_PREFIX = '&tbm=isch&start='.freeze
  HTML_PREFIX = '<html><head><title>dummy</title></head><body>'.freeze
  HTML_SUFFIX = '</body></html>'.freeze

  # regex for image links
  IMAGES_PROTOCOL = 'https:\/\/'.freeze
  IMAGES_DOMAIN = 'encrypted-tbn(0|1|2|3)\.gstatic\.com\/images'.freeze
  IMAGES_QUERY = '\?q=tbn:.{50,70}'.freeze
  IMAGES_REGEX = /^#{IMAGES_PROTOCOL + IMAGES_DOMAIN + IMAGES_QUERY}$/

  # tag name for parse
  IMG_TAG = 'img'.freeze
  SRC_TAG = 'src'.freeze

  # http request
  SLEEP_TIME = 2

  # name, directory for save images
  NAME_SEPARATOR = 'images?q=tbn:'.freeze
  NAME_SUFFIX = '.jpg'.freeze
  ASSETS_PATH = (Dir.pwd + File::SEPARATOR + 'assets' + File::SEPARATOR).freeze
  ORIGINALS_PATH = (ASSETS_PATH + 'originals' + File::SEPARATOR).freeze

  # pagination
  MAX_IMAGES_COUNT = 30
  PER = 20

  # Initial File size in originals path
  INITIAL_FILE_COUNT_IN_ORIGINALS = Dir.entries(ORIGINALS_PATH).length

  # ----------------------------------------
  # main action
  # ----------------------------------------

  # crawl - save original image files from google images with keyword
  def crawl_images(keyword)
    start = 0
    until enough?(ORIGINALS_PATH, MAX_IMAGES_COUNT)
      scrape_images(keyword, start.to_s)
      start += PER
    end
  end

  # ----------------------------------------
  # sub action
  # ----------------------------------------

  # scrape - save original image files from google images with keyword
  def scrape_images(keyword, start_str)
    uri = create(keyword, start_str)
    response = search uri
    images = parse response
    # TODO: validate images (size, already exist)
    save(images, ORIGINALS_PATH, MAX_IMAGES_COUNT)
  end

  # ----------------------------------------
  # support action
  # ----------------------------------------

  # create uri to search google images with keyword
  def create(keyword, start_str)
    uri = SEARCH_QUERY_PREFIX + keyword
    uri += SEARCH_START_PREFIX + start_str
    uri
  end

  # get Nokogiri::HTML object after search google images with uri
  def search(uri)
    response = open(uri, &:read).toutf8
    sleep(SLEEP_TIME)
    response = Nokogiri::HTML(HTML_PREFIX + response + HTML_SUFFIX)
    response
  end

  # extract url list about images from response Nokogiri::HTML object
  def parse(response)
    array = []
    response.search(IMG_TAG).each do |img|
      array << img[SRC_TAG] if IMAGES_REGEX =~ img[SRC_TAG]
    end
    array
  end

  # save original images
  def save(images, path, max)
    images.each do |image|
      break if enough?(path, max)
      name = path + image.split(NAME_SEPARATOR)[1] + NAME_SUFFIX
      File.write(name, open(image, &:read))
      sleep(SLEEP_TIME)
    end
  end

  # ----------------------------------------
  # helper methods
  # ----------------------------------------

  # check images count except for '.' and '..' and '.DS_Store' and '.keep'
  def enough?(path, max)
    Dir.entries(path).length - INITIAL_FILE_COUNT_IN_ORIGINALS >= max
  end
end
