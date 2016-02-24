# reductor class
class Reductor
  # ----------------------------------------
  # library
  # ----------------------------------------

  # ----------------------------------------
  # parameter
  # ----------------------------------------

  # file and directory
  ASSETS_PATH = (Dir.pwd + File::SEPARATOR + 'assets' + File::SEPARATOR).freeze
  ORIGINALS_PATH = (ASSETS_PATH + 'originals' + File::SEPARATOR).freeze
  ELEMENTS_PATH = (ASSETS_PATH + 'elements' + File::SEPARATOR).freeze

  # Initial Files in originals path like '.', '..', '.DS_Store', '.keep'
  INITIAL_FILES = Dir.entries(ORIGINALS_PATH).freeze

  # save images - size and color
  MIN_ORIGINAL_LENGTH = 50
  RESIZED_LENGTH = 100
  COLOR_VARIATION = 256

  def init
    # TODO: set parameters
  end

  # ----------------------------------------
  # main action
  # ----------------------------------------

  # TODO: to grayscale 100 * 100
  # TODO: to 1 * 1

  # ----------------------------------------
  # helper methods - foo bar
  # ----------------------------------------
end
