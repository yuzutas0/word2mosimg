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

  # element file and directory
  ELEMENTS_PATH = (ASSETS_PATH + 'elements' + File::SEPARATOR).freeze
  ELEMENTS_SIDE_LENGTH = 100

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

  # TODO: to gray scale 100 * 100 in originals
  # todo get images in originals path(.jpg)

  # TODO: to 1 * 1

  # ----------------------------------------
  # helper methods - foo bar
  # ----------------------------------------
end
