# crawler class
class Crawler
  # ----------------------------------------
  # library
  # ----------------------------------------

  require 'open-uri'
  require 'kconv'
  require 'nokogiri'
  require 'RMagick'

  # ----------------------------------------
  # parameter
  # ----------------------------------------

  # request for google images
  SEARCH_QUERY_PREFIX = 'https://www.google.co.jp/search?q='.freeze
  SEARCH_START_PREFIX = '&tbm=isch&start='.freeze
  HTML_PREFIX = '<html><head><title>dummy</title></head><body>'.freeze
  HTML_SUFFIX = '</body></html>'.freeze
  SLEEP_TIME = 1
  MAX_IMAGES_COUNT = 40000
  PER = 20
  MAX_REQUEST_COUNT = 10000 * PER

  # parse image links
  IMAGES_PROTOCOL = 'https:\/\/'.freeze
  IMAGES_DOMAIN = 'encrypted-tbn(0|1|2|3|4|5|6|7|8|9)\.gstatic\.com\/images'.freeze
  IMAGES_QUERY = '\?q=tbn:.{34,94}'.freeze
  IMAGES_REGEX = /^#{IMAGES_PROTOCOL + IMAGES_DOMAIN + IMAGES_QUERY}$/
  IMG_TAG = 'img'.freeze
  SRC_TAG = 'src'.freeze

  # save images - file and directory
  NAME_SEPARATOR = 'images?q=tbn:'.freeze
  NAME_SUFFIX = '.jpg'.freeze
  ASSETS_PATH = (Dir.pwd + File::SEPARATOR + 'assets' + File::SEPARATOR).freeze
  ORIGINALS_PATH = (ASSETS_PATH + 'originals' + File::SEPARATOR).freeze
  ELEMENTS_PATH = (ASSETS_PATH + 'elements' + File::SEPARATOR).freeze

  # Initial File size in originals path like '.', '..', '.DS_Store', '.keep'
  INITIAL_FILE_COUNT_IN_ORIGINALS = Dir.entries(ORIGINALS_PATH).length

  # save images - size and color
  MIN_ORIGINAL_LENGTH = 50
  RESIZED_LENGTH = 100
  COLOR_VARIATION = 256

  def init
    @images = []
    self
  end

  # ----------------------------------------
  # main action
  # ----------------------------------------

  # crawl - save original image files from google images with keyword
  def crawl_images(keyword)
    start = 0
    until enough? || limit?(start)
      scrape_images(keyword, start.to_s)
      start += PER
    end
  end

  # ----------------------------------------
  # helper methods - crawler condition
  # ----------------------------------------

  # check images count except for initial files
  def enough?
    present_file_count = Dir.entries(ORIGINALS_PATH).length
    images_count = present_file_count - INITIAL_FILE_COUNT_IN_ORIGINALS
    images_count >= MAX_IMAGES_COUNT
  end

  # check the count of http request
  def limit?(start)
    start >= MAX_REQUEST_COUNT
  end

  # ----------------------------------------
  # helper methods - scrape
  # ----------------------------------------

  # scrape - save original image files from google images with keyword
  def scrape_images(keyword, start_str)
    images = de_dupe parse search uri(keyword, start_str)
    @images << images
    save images
  end

  # ----------------------------------------
  # helper methods - get image uri list
  # ----------------------------------------

  # create uri to search google images with keyword
  def uri(keyword, start_str)
    SEARCH_QUERY_PREFIX + keyword + SEARCH_START_PREFIX + start_str
  end

  # get Nokogiri::HTML object after search google images with uri
  def search(uri)
    response = open(uri, &:read).toutf8
    sleep SLEEP_TIME
    Nokogiri::HTML(HTML_PREFIX + response + HTML_SUFFIX)
  end

  # extract url list about images from response Nokogiri::HTML object
  def parse(response)
    array = []
    response.search(IMG_TAG).each do |img|
      array << img[SRC_TAG] if IMAGES_REGEX =~ img[SRC_TAG]
    end
    array
  end

  # extract url list except for already exist
  def de_dupe(images)
    array = []
    images.each { |img| array << img unless @images.include?(img) }
    array
  end

  # ----------------------------------------
  # helper methods - save images
  # ----------------------------------------

  # save images
  def save(images)
    images.each do |image|
      break if enough?
      base_name = image.split(NAME_SEPARATOR)[1]
      original_name = ORIGINALS_PATH + base_name + NAME_SUFFIX
      element_name = ELEMENTS_PATH + base_name + NAME_SUFFIX
      post(original_name, element_name, image)
    end
  end

  # post binary
  def post(original_name, element_name, image)
    download(original_name, image)
    img = Magick::ImageList.new(original_name)
    if check? img
      export(img, element_name)
    else
      File.delete original_name
    end
    img.destroy!
  end

  # download image file
  def download(original_name, image)
    File.write(original_name, open(image, &:read))
    sleep SLEEP_TIME
  end

  # check image size
  def check?(img)
    size_vector = [img.columns, img.rows].sort!
    smaller = size_vector[0]
    larger = size_vector[1]
    smaller >= MIN_ORIGINAL_LENGTH && larger <= smaller * 2
  end

  # export image file
  def export(img, element_name)
    img = img.resize(RESIZED_LENGTH, RESIZED_LENGTH)
    img = img.quantize(COLOR_VARIATION, Magick::GRAYColorspace)
    img.write(element_name)
  end
end
