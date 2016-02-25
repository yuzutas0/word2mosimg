# Analyzer class
class Analyzer
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

  # try to get color feature of pixels and targets combination
  def diff_colors
    puts 'target: ' + message(target_colors)
    # => target: [153,  29,  33,   37,   26,   43,   48, 9629] for my example

    puts 'pixels: ' + message(pixels_colors)
    # => pixels: [157, 514, 940, 1740, 2202, 2353, 1466,  625] for my example
  end

  # ----------------------------------------
  # helper methods - common
  # ----------------------------------------

  def message(colors)
    str = '['
    colors.each do |color|
      str += color.to_s
      str += ',' if color != colors[-1]
    end
    str += ']'
    str
  end

  # ----------------------------------------
  # helper methods - target
  # ----------------------------------------

  # try to get color feature of targets
  def target_colors
    target_file = TARGET_FILE_NAME + NEW_TARGET_NAME_SUFFIX + FILE_SUFFIX
    img = Magick::ImageList.new(target_file)
    pixels = img.get_pixels(0, 0, img.columns, img.rows)
    target_colors = [0, 0, 0, 0, 0, 0, 0, 0]
    pixels.each { |pixel| color_variation(pixel, target_colors) }
    target_colors = normalize_color_variation(target_colors)
    target_colors
  end

  # ----------------------------------------
  # helper methods - pixel
  # ----------------------------------------

  # try to get color feature of pixels
  def pixels_colors
    image_name_list = get_image_name_list PIXELS_PATH
    pixel_colors = [0, 0, 0, 0, 0, 0, 0, 0]
    image_name_list.each do |image_name|
      pixel_color_variation(image_name, pixel_colors)
    end
    pixel_colors = normalize_color_variation(pixel_colors)
    pixel_colors
  end

  def pixel_color_variation(image_name, pixel_colors)
    img = Magick::ImageList.new(image_name)
    pixels = img.get_pixels(0, 0, img.columns, img.rows)
    pixel = pixels[0]
    color_variation(pixel, pixel_colors)
    img.destroy!
  end

  # get images(.jpg) in the path
  # same as reductor
  def get_image_name_list(path)
    image_name_list = []
    Dir.glob(path + '*' + FILE_SUFFIX).each do |file|
      image_name_list << file
    end
    image_name_list
  end

  # ----------------------------------------
  # helper methods - color
  # ----------------------------------------

  def color_variation(pixel, colors)
    pixel_l = pixel.to_hsla[2].to_i
    (0..7).each do |number|
      minimum = 32 * number
      maximum = 32 * (number + 1)
      colors[number] += 1 if pixel_l >= minimum && pixel_l < maximum
    end
  end

  def normalize_color_variation(colors)
    result = [0, 0, 0, 0, 0, 0, 0, 0]
    colors.each_with_index do |color, index|
      result[index] = 10_000 * color / colors.inject(:+)
    end
    result
  end
end
