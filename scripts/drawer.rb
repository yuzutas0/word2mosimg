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
  PNG_FILE_SUFFIX = '.png'.freeze
  TEXT_FILE_SUFFIX = '.txt'.freeze

  # combination
  COMBINATION_PATH = (ASSETS_PATH + 'combinations' + File::SEPARATOR).freeze
  COMBINATION_FILE_NAME = (COMBINATION_PATH + 'index' + TEXT_FILE_SUFFIX).freeze
  COMBINATION_SEPARATOR = ','.freeze

  # element
  ELEMENTS_PATH = (ASSETS_PATH + 'elements' + File::SEPARATOR).freeze

  # draw
  DRAW_PATH = (ASSETS_PATH + 'draws' + File::SEPARATOR).freeze
  SIDE_PICTURES_COUNT = 200
  DRAW_LINE_FILE_NAME_PREFIX = (DRAW_PATH + 'line_').freeze
  DRAW_MOSAIC_FILE_NAME = (DRAW_PATH + 'mosaic' + PNG_FILE_SUFFIX).freeze

  def init
    self
  end

  # ----------------------------------------
  # main action
  # ----------------------------------------

  def draw
    # image_name_list = get_image_name_list COMBINATION_FILE_NAME
    # (0..SIDE_PICTURES_COUNT - 1).each do |index|
    #   make_image_for_line(index, image_name_list)
    # end
    make_mosaic_image
  end

  # ----------------------------------------
  # helper methods - xxx
  # ----------------------------------------

  # import from combination index
  def get_image_name_list(filename)
    text = File.read filename
    image_name_list = text.split COMBINATION_SEPARATOR
    image_name_list
  end

  # export image about the line
  def make_image_for_line(index, image_name_list)
    image_name_list_for_line = get_list_for_line(index, image_name_list)
    line_image = Magick::ImageList.new
    image_name_list_for_line.each do |image_name|
      pixel_image = Magick::ImageList.new(ELEMENTS_PATH + image_name)
      line_image << pixel_image.append(false)
      pixel_image.destroy!
    end
    image_name = get_image_name(index)
    line_image.append(false).write(image_name)
    line_image.destroy!
  end

  # choose image only about the line
  def get_list_for_line(index, image_name_list)
    first_image_index = index * SIDE_PICTURES_COUNT
    last_image_index = first_image_index + SIDE_PICTURES_COUNT - 1
    list_for_line = image_name_list[first_image_index..last_image_index]
    list_for_line
  end

  # get image name about the line
  def get_image_name(index)
    index_string = format('%03d', index)
    image_name = DRAW_LINE_FILE_NAME_PREFIX + index_string + JPG_FILE_SUFFIX
    image_name
  end

  # export mosaic image based on each line images
  def make_mosaic_image
    mosaic_image = Magick::ImageList.new
    (0..SIDE_PICTURES_COUNT - 1).each do |index|
      line_image_name = get_image_name(index)
      line_image = Magick::ImageList.new(line_image_name)
      mosaic_image << line_image.append(true)
      line_image.destroy!
    end
    mosaic_image.append(true).write(DRAW_MOSAIC_FILE_NAME)
    mosaic_image.destroy!
  end
end
