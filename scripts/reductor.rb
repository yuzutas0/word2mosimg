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
    self
  end

  # ----------------------------------------
  # main action
  # ----------------------------------------

  # reduction of target file
  def target
    img = Magick::ImageList.new(TARGET_FILE_NAME + FILE_SUFFIX)
    img = img.resize(NEW_TARGET_SIDE_LENGTH, NEW_TARGET_SIDE_LENGTH)
    img = img.quantize(COLOR_VARIATION, Magick::GRAYColorspace)
    img.write(TARGET_FILE_NAME + NEW_TARGET_NAME_SUFFIX + FILE_SUFFIX)
    img.destroy!
  end

  # reduction of original files to elements
  def element
    image_name_list = get_image_name_list ORIGINALS_PATH
    image_name_list.each { |image_name| post(image_name) }
  end

  # reduction of element files to pixels
  def pixel
    image_name_list = get_image_name_list ELEMENTS_PATH
    image_name_list.each { |image_name| minimize(image_name) }
  end

  # try to get color feature of pixels
  def get_colors
    image_name_list = get_image_name_list PIXELS_PATH
    l_of_hsla = []
    image_name_list.each { |image_name|
      img = Magick::ImageList.new(image_name)
      pixels = img.get_pixels(0, 0, img.columns, img.rows)
      puts image_name.to_s + ' is not 1 pixel !!! /n' if pixels.length != 1 # => none
      for pixel in pixels
        puts image_name.to_s + ' is not pure gray !!! /n' if [pixel.red, pixel.green, pixel.blue].uniq.length != 1
        puts image_name.to_s + ' is not h = 0.0 !!! /n' if pixel.to_hsla[0] != 0.0 # => none
        puts image_name.to_s + ' is not s = 0.0 !!! /n' if pixel.to_hsla[1] != 0.0 # => none
        puts image_name.to_s + ' is not a = 1.0 !!! /n' if pixel.to_hsla[3] != 1.0 # => none
        puts image_name.to_s + ' is not l = red / 256 !!! /n' if (pixel.red / 256) != pixel.to_hsla[2].to_i # => none
        l_of_hsla << pixel.to_hsla[2]
      end
      img.destroy!
    }
    puts 'min l is ' + l_of_hsla.sort[0].to_s + ' !!! /n' # => 9.0 for my example
    puts 'max l is ' + l_of_hsla.sort[-1].to_s + ' !!! /n' # => 251.0 for my example
  end

  # ----------------------------------------
  # helper methods - element and pixel
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
      element_name = ELEMENTS_PATH + File.basename(original_name)
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

  # ----------------------------------------
  # helper methods - pixel
  # ----------------------------------------
  def minimize(element_name)
    img = Magick::ImageList.new(element_name)
    img = img.resize(PIXELS_SIDE_LENGTH, PIXELS_SIDE_LENGTH)
    pixel_name = PIXELS_PATH + File.basename(element_name)
    img.write(pixel_name)
    img.destroy!
  end
end
