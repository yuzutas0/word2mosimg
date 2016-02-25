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
  JPG_FILE_SUFFIX = '.jpg'.freeze

  # target file and directory
  TARGET_FILE_PATH = (ASSETS_PATH + 'targets' + File::SEPARATOR).freeze
  TARGET_FILE_NAME = (TARGET_FILE_PATH + 'zeta').freeze
  NEW_TARGET_NAME_SUFFIX = '_new'.freeze

  # pixel file and directory
  PIXELS_PATH = (ASSETS_PATH + 'pixels' + File::SEPARATOR).freeze

  # divided file and directory
  DIVIDED_PATH = (ASSETS_PATH + 'divideds' + File::SEPARATOR).freeze

  # export file
  TEXT_FILE_SUFFIX = '.txt'.freeze
  EXPORT_TARGET_FILE_PATH = (DIVIDED_PATH + 'target' + TEXT_FILE_SUFFIX).freeze
  EXPORT_LIST_SEPARATOR = ','.freeze
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
    # => like this: '1,0,3, ... 6,4,2'

    pixels_color_list.each_with_index do |pixels_color_str, index|
      path = DIVIDED_PATH + 'elements' + index.to_s + JPG_FILE_SUFFIX
      export(path, pixels_color_str)
    end
    # => like this: 0 - 'hoge.jpg,foobar.jpg, ... ,last.jpg'
    # => like this: 1 - 'hoge.jpg,foobar.jpg, ... ,last.jpg'
    # => like this: ...
    # => like this: 7 - 'hoge.jpg,foobar.jpg, ... ,last.jpg'
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
    Dir.glob(path + '*' + JPG_FILE_SUFFIX).each do |file|
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
    target_file = TARGET_FILE_NAME + NEW_TARGET_NAME_SUFFIX + JPG_FILE_SUFFIX
    img = Magick::ImageList.new(target_file)
    pixels = img.get_pixels(0, 0, img.columns, img.rows)
    pixels.each do |pixel|
      color_list = target_color_variation(pixel, color_list)
    end
    img.destroy!
    color_list.chop!
    color_list
  end

  # get string about color list with the pixel
  def target_color_variation(pixel, color_list)
    string = String.new(color_list)
    pixel_l = pixel.to_hsla[2].to_i
    string += pattern(pixel_l).to_s + EXPORT_LIST_SEPARATOR
    string
  end

  # ----------------------------------------
  # helper methods - pixels
  # ----------------------------------------

  # get string about color list of pixels
  def pixels_color_list
    color_list = ['', '', '', '', '', '', '', '']
    image_name_list = get_image_name_list PIXELS_PATH
    image_name_list.each do |image_name|
      color_list = pixel_color_list(image_name, color_list)
    end
    color_list.each(&:chop!)
    color_list
    # => like this: ['hogehoge.jpg,foobar.jpg', ... 'last.jpg,final.jpg']
  end

  # get string about color list with the pixel
  def pixel_color_list(image_name, color_list)
    array = Array.new(color_list)
    img = Magick::ImageList.new(image_name)
    pixels = img.get_pixels(0, 0, img.columns, img.rows)
    pixel_l = pixels[0].to_hsla[2].to_i
    array[pattern(pixel_l)] += File.basename(image_name) + EXPORT_LIST_SEPARATOR
    img.destroy!
    array
  end

  # ----------------------------------------
  # helper methods - color pattern
  # ----------------------------------------

  # get string about color list with the pixel - divide 8 pattern here
  def pattern(pixel_l)
    result = 0
    (0..7).each do |index|
      minimum = 32 * index
      maximum = 32 * (index + 1)
      result = index if pixel_l >= minimum && pixel_l < maximum
    end
    result
  end
end
