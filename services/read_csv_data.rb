class ReadCsvData
  def self.call(path)
    @path = path
    valid_file? or raise ArgumentError, @error || 'Invalid CSV File'
    new(path).call
  end

  def initialize(path)
    @path = path
  end

  def call
    parse_csv_data
  end

  private

  def self.valid_file?
    File.extname(@path) == '.csv' &&
      open(@path).read
  rescue Errno::ENOENT => e
    @error = e.message
    false
  end

  def parse_csv_data
    csv_data = open(@path).read
    parsed_csv_data = CSV.parse(csv_data)
    # shift to remove column names
    parsed_csv_data.shift
    parsed_csv_data
  end
end
