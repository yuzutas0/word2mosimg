# reductor class
class Reductor
  # ----------------------------------------
  # library
  # ----------------------------------------

  require 'RMagick'

  # ----------------------------------------
  # parameter
  # ----------------------------------------

  # common
  ASSETS_PATH = (Dir.pwd + File::SEPARATOR + 'assets' + File::SEPARATOR).freeze
  FILE_SUFFIX = '.jpg'.freeze
  COLOR_VARIATION = 256

  # target file and directory
  TARGET_FILE_PATH = (ASSETS_PATH + 'targets' + File::SEPARATOR).freeze
  TARGET_FILE_NAME = (TARGET_FILE_PATH + 'zeta').freeze
  NEW_TARGET_SIDE_LENGTH = 200
  NEW_TARGET_NAME_SUFFIX = '_new'.freeze

  # original file and directory
  ORIGINALS_PATH = (ASSETS_PATH + 'originals' + File::SEPARATOR).freeze
  ORIGINALS_NAME_SEPARATOR = 'images?q=tbn:'.freeze
  MIN_ORIGINAL_LENGTH = 50

  # element file and directory
  ELEMENTS_PATH = (ASSETS_PATH + 'elements' + File::SEPARATOR).freeze
  ELEMENTS_SIDE_LENGTH = 100

  # pixel file and directory
  PIXELS_PATH = (ASSETS_PATH + 'pixels' + File::SEPARATOR).freeze
  PIXELS_SIDE_LENGTH = 1

  def init
    # TODO: set parameters
    self
  end

  # ----------------------------------------
  # main action
  # ----------------------------------------

  # reduction of target file
  def target
    img = Magick::ImageList.new(TARGET_FILE_NAME + FILE_SUFFIX)
    resized = img.resize(NEW_TARGET_SIDE_LENGTH, NEW_TARGET_SIDE_LENGTH)
    grayed = resized.quantize(COLOR_VARIATION, Magick::GRAYColorspace)
    grayed.write(TARGET_FILE_NAME + NEW_TARGET_NAME_SUFFIX + FILE_SUFFIX)
    [img, resized, grayed].each(&:destroy!)
  end

  # reduction of original file to elements
  def element
    image_name_list = get_image_name_list ORIGINALS_PATH
    image_name_list.each { |image_name| post(image_name) }
  end

  # TODO: to 1 * 1

  # ----------------------------------------
  # helper methods - target
  # ----------------------------------------

  # get images(.jpg) in the path
  def get_image_name_list(path)
    image_name_list = []
    Dir.glob(path + '*' + FILE_SUFFIX).each do |file|
      image_name_list << file
    end
    image_name_list
  end

  # ----------------------------------------
  # helper methods - element
  # ----------------------------------------

  # customize and through original image to the element path
  def post(original_name)
    img = Magick::ImageList.new(original_name)
    if check? img
      element_name = ELEMENTS_PATH + File.basename(image_name)
      export(img, element_name)
    else
      File.delete original_name
    end
    img.destroy!
  end

  # check image size
  def check?(img)
    size_vector = [img.columns, img.rows].sort!
    smaller = size_vector[0]
    larger = size_vector[1]
    smaller >= MIN_ORIGINAL_LENGTH && larger <= smaller * 2
  end

  # export image file resized and gray scaled
  def export(img, element_name)
    img = img.resize(ELEMENTS_SIDE_LENGTH, ELEMENTS_SIDE_LENGTH)
    img = img.quantize(COLOR_VARIATION, Magick::GRAYColorspace)
    img.write(element_name)
  end
end
