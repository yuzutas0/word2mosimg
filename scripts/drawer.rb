# Drawer class
class Drawer
  # ----------------------------------------
  # library
  # ----------------------------------------

  require 'RMagick'

  # ----------------------------------------
  # parameter
  # ----------------------------------------

  # common
  ASSETS_PATH = (Dir.pwd + File::SEPARATOR + 'assets' + File::SEPARATOR).freeze
  JPG_FILE_SUFFIX = '.jpg'.freeze
  TEXT_FILE_SUFFIX = '.txt'.freeze

  # combination
  COMBINATION_PATH = (ASSETS_PATH + 'combinations' + File::SEPARATOR).freeze
  COMBINATION_FILE_NAME = (COMBINATION_PATH + 'index' + TEXT_FILE_SUFFIX).freeze
  COMBINATION_SEPARATOR = ','.freeze

  # element
  ELEMENTS_PATH = (ASSETS_PATH + 'elements' + File::SEPARATOR).freeze

  # draw
  DRAW_PATH = (ASSETS_PATH + 'draws').freeze
  SIDE_PICTURES_COUNT = 200
  # TODO: line file is line_001.jpg - line_200.jpg
  DRAW_LINE_FILE_NAME_PREFIX = (DRAW_PATH + 'line_').freeze
  DRAW_MOSAIC_FILE_NAME = (DRAW_PATH + 'mosaic' + JPG_FILE_SUFFIX).freeze

  def init
    self
  end

  # ----------------------------------------
  # main action
  # ----------------------------------------

  def draw
    # import from combination index
    image_name_list = get_image_name_list COMBINATION_FILE_NAME
    puts image_name_list[0..10]
    # TODO: loop for line 001 - 200
    # TODO: connect images for the line
    # TODO: export connected image to draws
    # TODO: connect each line images after loop
  end

  # ----------------------------------------
  # helper methods - xxx
  # ----------------------------------------

  # get array about image files combined with the target image
  def get_image_name_list(filename)
    text = File.read filename
    image_name_list = text.split COMBINATION_SEPARATOR
    image_name_list
  end
end
