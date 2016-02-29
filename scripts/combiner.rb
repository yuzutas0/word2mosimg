# combiner class
class Combiner
  # ----------------------------------------
  # library
  # ----------------------------------------

  # as necessary

  # ----------------------------------------
  # parameter
  # ----------------------------------------

  # common
  ASSETS_PATH = (Dir.pwd + File::SEPARATOR + 'assets' + File::SEPARATOR).freeze
  TEXT_FILE_SUFFIX = '.txt'.freeze
  EXPORT_LIST_SEPARATOR = ','.freeze

  # devided
  DIVIDED_PATH = (ASSETS_PATH + 'divideds' + File::SEPARATOR).freeze
  TARGET_FILE_PATH = (DIVIDED_PATH + 'zeta' + TEXT_FILE_SUFFIX).freeze
  ELEMENT_FILE_PREFIX = (DIVIDED_PATH + 'elements').freeze

  # combination
  COMBINED_PATH = (ASSETS_PATH + 'combinations' + File::SEPARATOR).freeze
  COMBINED_FILE_PREFIX = 'line'.freeze

  def init
    self
  end

  # ----------------------------------------
  # main action
  # ----------------------------------------

  def combine
    target_array = acquire_target_array
    element_array_list = acquire_element_array_list

    element_init_count = acquire_element_init_count(element_array_list)
    element_temp_count = acquire_element_temp_count(element_array_list)
    combination_array = []

    # output: array of jpg files
    target_array.each do |target_number|
      # target number -> jpg file
    end
  end

  # ----------------------------------------
  # helper methods - xxx
  # ----------------------------------------

  # get target array form text file
  def acquire_target_array
    File.read(TARGET_FILE_PATH).split(EXPORT_LIST_SEPARATOR)
  end

  # get element array list from text files
  def acquire_element_array_list
    element_array_list = []
    [0..7].each do |number|
      element_file_name = ELEMENT_FILE_PREFIX + number.to_s + TEXT_FILE_SUFFIX
      element_array = File.read(element_file_name)
      element_array_list[number] = element_array.split(EXPORT_LIST_SEPARATOR)
    end
    element_array_list
  end

  # get size list of each element array
  def acquire_element_init_count(element_array_list)
    element_init_count = []
    element_array_list.each_with_index do |element_array, index|
      element_init_count[index] = element_array.length
    end
    element_init_count
  end

  # set 0 array whose length equals element array list
  def acquire_element_temp_count(element_array_list)
    element_temp_count = []
    [0..(element_array_list.length - 1)].each do |count|
      element_temp_count[count] = 0
    end
    element_temp_count
  end
end
