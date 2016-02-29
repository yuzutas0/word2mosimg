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
  TARGET_FILE_PATH = (DIVIDED_PATH + 'target' + TEXT_FILE_SUFFIX).freeze
  ELEMENT_FILE_PREFIX = (DIVIDED_PATH + 'elements').freeze

  # combination
  COMBINED_PATH = (ASSETS_PATH + 'combinations' + File::SEPARATOR).freeze
  COMBINED_FILE_NAME = (COMBINED_PATH + 'index' + TEXT_FILE_SUFFIX).freeze

  # export
  EXPORT_MESSAGE = 'Finish: export '.freeze

  # ----------------------------------------
  # main action
  # ----------------------------------------

  # init each param
  def init
    # import text files
    @target_array = acquire_target_array
    @element_array_list = acquire_element_array_list

    # set count
    @init_count = acquire_element_init_count(@element_array_list)
    @temp_count = acquire_element_temp_count(@element_array_list)

    self
  end

  # export file about combination of element and target
  def combine
    # init string
    string = ''

    # set string
    @target_array.each do |target_string|
      target = target_string.to_i
      @temp_count[target] = next_count(@temp_count, @init_count, target)
      string += @element_array_list[target][@temp_count[target]]
      string += EXPORT_LIST_SEPARATOR
    end

    # export string
    export(COMBINED_FILE_NAME, string.chop!)
    puts string.split(EXPORT_LIST_SEPARATOR).length.to_s
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
    (0..7).each do |number|
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
      element_init_count[index] = element_array.length - 1
    end
    element_init_count
  end

  # set 0 array whose length equals element array list
  def acquire_element_temp_count(element_array_list)
    element_temp_count = []
    (0..(element_array_list.length - 1)).each do |count|
      element_temp_count[count] = 0
    end
    element_temp_count
  end

  def next_count(temp_count, init_count, target)
    count = temp_count[target] + 1
    count = 0 unless count <= init_count[target]
    count
  end

  # same as other class
  def export(file_path, string)
    File.write(file_path, string)
    puts EXPORT_MESSAGE + file_path
  end
end
