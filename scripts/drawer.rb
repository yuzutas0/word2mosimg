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
  COMBINATION_PATH = (ASSETS_PATH + 'combinations').freeze
  COMBINATION_FILE_NAME = (COMBINATION_PATH + 'index' + TEXT_FILE_SUFFIX).freeze

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

  # ----------------------------------------
  # helper methods - xxx
  # ----------------------------------------
end
