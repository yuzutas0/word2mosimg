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

  # divided file and directory
  DIVIDED_PATH = (DIVIDED_PATH + 'pixels' + File::SEPARATOR).freeze

  # export file
  EXPORT_TARGET_FILE_PATH = (DIVIDED_PATH + 'target' + FILE_SUFFIX).freeze
  EXPORT_MESSAGE = 'Finish: export '.freeze

  def init
    self
  end

  # ----------------------------------------
  # main action
  # ----------------------------------------

  # try to set color feature of pixels and targets combination to file
  def divide
    export(EXPORT_TARGET_FILE_PATH, target_color_list)
    pixels_color_list.each_with_index do |pixels_color_str, index|
      path = DIVIDED_PATH + 'elements' + index.to_s + FILE_SUFFIX
      export(path, pixels_color_str)
    end
  end

  # ----------------------------------------
  # helper methods - files
  # ----------------------------------------

  # export text file
  def export(file_path, string)
    File.write(file_path, string)
    puts EXPORT_MESSAGE + file_path
  end

  # get images(.jpg) in the path
  # same as other files
  def get_image_name_list(path)
    image_name_list = []
    Dir.glob(path + '*' + FILE_SUFFIX).each do |file|
      image_name_list << file
    end
    image_name_list
  end

  # ----------------------------------------
  # helper methods - target
  # ----------------------------------------

  # get string about color list of target
  def target_color_list
    color_list = ''
    # TODO: get image
    # TODO: pixel -> loop
    # TODO: get color -> divide 8 pattern
    color_list
    # => like this: ['0, 2, 0, 2, 0, ..., 0, 6, 3']
  end

  # ----------------------------------------
  # helper methods - pixels
  # ----------------------------------------

  # get string about color list of pixels
  def pixels_color_list
    color_list = ['', '', '', '', '', '', '', '']
    # TODO: get images -> loop
    # TODO: get image color -> divide 8 pattern
    color_list
    # => like this: ['hogehoge.jpg, foobar.jpg', ... 'last.jpg, final.jpg']
  end
end
