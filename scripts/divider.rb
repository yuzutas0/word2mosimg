# Divider class
class Divider
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

  # target file and directory
  TARGET_FILE_PATH = (ASSETS_PATH + 'targets' + File::SEPARATOR).freeze
  TARGET_FILE_NAME = (TARGET_FILE_PATH + 'zeta').freeze
  NEW_TARGET_NAME_SUFFIX = '_new'.freeze

  # pixel file and directory
  PIXELS_PATH = (ASSETS_PATH + 'pixels' + File::SEPARATOR).freeze

  def init
    self
  end

  # ----------------------------------------
  # main action
  # ----------------------------------------

  # try to set color feature of pixels and targets combination to file
  def divide
    # TODO: pixels feature to file
    # TODO: targets feature to file
  end

  # ----------------------------------------
  # helper methods - xxx
  # ----------------------------------------
end
